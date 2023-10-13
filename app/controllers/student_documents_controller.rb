class StudentDocumentsController < ApplicationController
  before_action :set_student_document, only: %i[ show edit update destroy ]

  # GET /student_documents or /student_documents.json
  def index
    @student_document = StudentDocument.find_or_initialize_by(email_id: session[:email]) 
    @student_data = Student.find_or_initialize_by(email_id: session[:email])
    if !@student_document
      flash.now[:error] =  "No student found with this email ID"
    end
  end

  # GET /student_documents/1 or /student_documents/1.json
  def show
    @student_documents = StudentDocument.find_or_initialize_by(email_id: session[:email]) 
  end

  # GET /student_documents/new
  def new
    @student_document = StudentDocument.new
  end

  # GET /student_documents/1/edit
  def edit
  end

  # POST /student_documents or /student_documents.json

  def create
   # @student_document = StudentDocument.new(student_document_params)
    @student_document = StudentDocument.find_or_initialize_by(email_id: session[:email]) 
    respond_to do |format|
      if @student_document.save
        format.html { redirect_to student_document_url(@student_document), notice: "Student document was successfully created." }
        format.json { render :show, status: :created, location: @student_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student_document.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /student_documents/1 or /student_documents/1.json
  def update

    if @student_document.save 
   
      if params[:student_document][:resume_file]
     
        #save the resume in s3 bucket in the name of email id. This will be file key
        @current_email = session[:email]
        @input_string_resume = @current_email
        @replacement_string = "_resume"
        @input_string.gsub!(/@tamu\.edu/, @replacement_string)
        
        #store the resume file name in database
        @student_document.update(resume_file: @input_string)
      
        #upload resume in s3 bucket
        s3 = Aws::S3::Resource.new(region: 'us-east-2')
        obj = s3.bucket('phd-annual-review-sys-docs')
        File.open( params[:student_document][:resume_file], 'rb') do |file|
          obj.put_object(body: file,  content_type: 'application/pdf', key:@input_string )
        end
        
        #get the url of uploaded resume from s3 bucket
        resp = Aws::S3::Client.new
        bucket_name = 'phd-annual-review-sys-docs'
        presigner = Aws::S3::Presigner.new(client: resp)
        presigned_url_resume = presigner.presigned_url(:get_object,bucket: bucket_name, key: @input_string_resume)
        presigned_url_report = presigner.presigned_url(:get_object,bucket: bucket_name, key: @input_string_report)
       
        #update the resume_link column with link to the resume file
        @student_document.update(resume_link: presigned_url_resume)
        @student_document.update(report_link: input_string_report)
        
        @student_document.update(phd_start_date: params[:student_document][:phd_start_date])
        @student_document.update(milestones_passed: params[:student_document][:milestones_passed])
        @student_document.update(improvement_plan_present: params[:student_document][:improvement_plan_present])
        @student_document.update(improvement_plan_summary: params[:student_document][:improvement_plan_summary])
        @student_document.update(gpa: params[:student_document][:gpa])
        @student_document.update(support_in_last_sem: params[:student_document][:support_in_last_sem])
        @student_document.update(number_of_paper_submissions: params[:student_document][:number_of_paper_submissions])
        @student_document.update(number_of_papers_published: params[:student_document][:number_of_papers_published])

        #render show to when resume is updloaded
        render :show
      else
        #flsh error when resume is not submitted
        redirect_to student_documents_path,  notice:"Error: Please select a file to upload!"
      end
    end
  end

  # DELETE /student_documents/1 or /student_documents/1.json
  def destroy
    @student_document.destroy

    respond_to do |format|
      format.html { redirect_to student_documents_url, notice: "Student document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_document
      @student_document = StudentDocument.find_or_initialize_by(email_id: session[:email])
      @student = Student.find_or_initialize_by(email_id: session[:email])
    end

    # Only allow a list of trusted parameters through.
    def student_document_params
      params.require(:student_document).permit(:resume_file, :resume_link, session[:email], :phd_start_date, :milestones_passed, :improvement_plan_present, :improvement_plan_summary, :gpa, :support_in_last_sem, :number_of_paper_submissions, :number_of_papers_published)
    end
end
class StudentDocumentsController < ApplicationController
  before_action :set_student_document, only: %i[ show edit update destroy ]

  # GET /student_documents or /student_documents.json
  def index
    @student_document = StudentDocument.find_or_initialize_by(email_id: session[:email]) 
    @student_data = Student.find_or_initialize_by(email_id: session[:email])
  end

  # GET /student_documents/1 or /student_documents/1.json
  def show
    @student_documents = StudentDocument.find_or_initialize_by(email_id: session[:email]) 
  end

  # GET /student_documents/new
  def new
    #@student_document = StudentDocument.new
  end

  # GET /student_documents/1/edit
  def edit
  end

  # POST /student_documents or /student_documents.json

  def create
   #  @student_document = StudentDocument.new(student_document_params)
    # @student_document = StudentDocument.find_or_initialize_by(email_id: session[:email]) 
  end


  # PATCH/PUT /student_documents/1 or /student_documents/1.json
  def update
    if params[:student_document][:support_in_last_sem_description].present?
      params[:student_document][:support_in_last_sem_description] = params[:student_document][:support_in_last_sem_description].reject(&:empty?)
    end
    current_email = session[:email].dup
    current_email.gsub!(/@tamu\.edu/, '')
    flash.clear

    # clear the session
    @student_document.resume_file  = nil
    @student_document.report_file  = nil
    @student_document.milestones_passed = nil
    @student_document.improvement_plan_present = nil
    @student_document.improvement_plan_summary = nil
    @student_document.gpa = nil
    @student_document.support_in_last_sem = nil
    @student_document.support_in_last_sem_description = nil
    @student_document.number_of_paper_submissions = nil
    @student_document.number_of_papers_published = nil
  
    if @student_document.update(student_document_params)
      if params[:student_document][:resume_file].present?
        
        #save the resume in s3 bucket in the name of email id. This will be file key
        input_string_resume = "#{current_email}_resume"

        #store the resume file name in database
        @student_document.update(resume_file: input_string_resume)

        #upload resume in s3 bucket
        s3 = Aws::S3::Resource.new(region: 'us-east-2')
        obj = s3.bucket('phd-annual-review-sys-docs')
        File.open( params[:student_document][:resume_file], 'rb') do |file|
          obj.put_object(body: file,  content_type: 'application/pdf', key:input_string_resume )
        end
        
        #get the uri of uploaded resume from s3 bucket
        resume_uri = 's3://'+ 'phd-annual-review-sys-docs/' + input_string_resume
        #update the resume_link column with link to the resume file
        @student_document.update(resume_link: resume_uri)
      end

      if params[:student_document][:report_file].present?
        
        #save the report in s3 bucket in the name of email id. This will be file key
        input_string_report = "#{current_email}_report"
        
        #store the report file name in database
        @student_document.update(report_file: input_string_report)
      
        #upload report in s3 bucket
        s3 = Aws::S3::Resource.new(region: 'us-east-2')
        obj = s3.bucket('phd-annual-review-sys-docs')
        File.open( params[:student_document][:report_file], 'rb') do |file|
          obj.put_object(body: file,  content_type: 'application/pdf', key:input_string_report )
        end

        report_uri = 's3://'+ 'phd-annual-review-sys-docs/' + input_string_report
        #update the report_link column with link to the report file
        @student_document.update(report_link: report_uri)
      end

        #update other columns
        @student_document.update(phd_start_date: params[:student_document][:phd_start_date])
        @student_document.update(milestones_passed: params[:student_document][:milestones_passed])
        @student_document.update(improvement_plan_present: params[:student_document][:improvement_plan_present])
        @student_document.update(improvement_plan_summary: params[:student_document][:improvement_plan_summary])
        @student_document.update(gpa: params[:student_document][:gpa])
        @student_document.update(support_in_last_sem: params[:student_document][:support_in_last_sem])
        @student_document.update(support_in_last_sem_description: params[:student_document][:support_in_last_sem_description])
        @student_document.update(number_of_paper_submissions: params[:student_document][:number_of_paper_submissions])
        @student_document.update(number_of_papers_published: params[:student_document][:number_of_papers_published])
        
        #redirect_to student_documents_path with success message
        flash[:notice] = "Details have been submitted."
        redirect_to student_documents_path
    else
      #redirect_to student_documents_path with error message
      flash[:notice] = "Errors while updating details."
      flash[:error] = @student_document.errors.full_messages
      redirect_to student_documents_path
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
      params.require(:student_document).permit(
        :resume_file, :report_file, session[:email], 
        :phd_start_date, 
        :improvement_plan_present, 
        :improvement_plan_summary, :gpa,
        :number_of_paper_submissions, :number_of_papers_published,
        support_in_last_sem: [], 
        milestones_passed: [],
        support_in_last_sem_description: [] # Permit milestones_passed as an array
      )
    end    
end
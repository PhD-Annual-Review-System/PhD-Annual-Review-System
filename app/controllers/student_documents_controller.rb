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
  
  end

  # PATCH/PUT /student_documents/1 or /student_documents/1.json
  def update
    if @student_document.save
      
      #set the content type of the file uploaded
      @content_type = params[:student_document][:resume_file].content_type
     
      #store the resume file name in database
      @student_document.update(resume_file: params[:student_document][:resume_file].original_filename)
      puts "Resume updated successfully."
      
      #save the resume in s3 bucket in the name of email id. This will be file key
      @input_string = session[:email]
      @replacement_string = "_resume"
      @input_string.gsub!(/@tamu\.edu/, @replacement_string)
      
      #upload resume in s3 bucket
      s3 = Aws::S3::Resource.new(region: 'us-east-2')
      obj = s3.bucket('phd-annual-review-sys-docs')
      File.open( params[:student_document][:resume_file].tempfile, 'rb') do |file|
        obj.put_object(body: file,  content_type: 'application/pdf', key:@input_string )
      end
      
      #get the url of uploaded resume from s3 bucket
      resp = Aws::S3::Client.new
      bucket_name = 'phd-annual-review-sys-docs'
      presigner = Aws::S3::Presigner.new(client: resp)
      presigned_url = presigner.presigned_url(:get_object,bucket: bucket_name, key: @input_string)
     
      #update the resume_link column with link to the resume file
      @student_document.update(resume_link: presigned_url)
      
      #render show to when resume is updloaded
      render :show
    else
      flash.now[:error] =  "Resume was not be updated."
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
      params.require(:student_document).permit(:resume_file, :resume_link, session[:email])
    end
end

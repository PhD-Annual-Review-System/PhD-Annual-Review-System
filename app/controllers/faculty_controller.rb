class FacultyController < ApplicationController
  before_action :require_login, only: [:dashboard]
    def login
      end
    
    def authenticate
      @faculty = Faculty.find_by(email_id: params[:faculty][:email_id])
      if @faculty && @faculty.authenticate(params[:faculty][:password])
        # Authentication successful. Store user information in the session.
        log_in(@faculty)
        # session[:email] = @faculty.email_id
        # session[:name] = @faculty.first_name
        redirect_to faculty_dashboard_path # Redirect to the faculty's dashboard.
      else
        # Authentication failed. Show an error message and render the login form again.
        flash.now[:error] = 'Invalid Email or password.'
        render :login
      end
    end


    def logout
      log_out
      # session[:email] = nil  # Clear the student's session
      # session[:name] = nil
      redirect_to faculty_login_path  # Redirect to the root page or login page
    end

    def dashboard
      @faculty = current_faculty
      if @faculty
        @students_to_review = Student.includes(:committees, :assessments).where(committees: { faculty_id: @faculty.id })
        @students_pending_assessment = []
        @students_completed_assessment = []
    
        @students_to_review.each do |student|
          if student.assessments.find { |a| a.faculty == @faculty }
            @students_completed_assessment << student
          else
            @students_pending_assessment << student
          end
        end
      else
        flash[:error] = 'You must be logged in to access the dashboard.'
        redirect_to faculty_login_path
      end
    end

    def review_student
      @student = Student.find(params[:id])
      @documents = StudentDocument.where(email_id: @student.email_id)
  
      if @documents.empty?
        @no_documents_message = 'This student has not submitted any documents.'
      else
        # Parse the S3 URI to extract bucket name and object key
        uri = URI.parse(@documents.first.resume_link)
        bucket_name = uri.host
        object_key = uri.path[1..-1] # Remove the leading '/'

        # Generate a presigned URL that expires in 1 week
        resp = Aws::S3::Client.new
        presigner = Aws::S3::Presigner.new(client: resp)
        @resume_url = presigner.presigned_url(:get_object,bucket: bucket_name, key: object_key, expires_in: 604800)
        
        # Parse the S3 URI to extract bucket name and object key
        uri = URI.parse(@documents.first.report_link)
        bucket_name = uri.host
        object_key = uri.path[1..-1] # Remove the leading '/'
        @report_url = presigner.presigned_url(:get_object,bucket: bucket_name, key: object_key, expires_in: 604800)
       
        @private_comments = Assessment.where(student_id: @student.id).where.not(faculty_id: current_faculty.id)
      end
    end

    def save_assessment
      @student = Student.find(params[:id])
  
      @assessment = Assessment.find_or_initialize_by(student: @student, faculty: current_faculty)
  
      if @assessment.update(assessment_params)
        flash[:success] = 'Assessment saved successfully.'
      else
        flash[:error] = 'Failed to save assessment.'
      end
  
      redirect_to faculty_dashboard_path
    end

    def view_assessment
      # Find the student based on the provided ID
      @student = Student.find(params[:id])
  
      # Find the assessment for the current faculty and student
      @assessment = Assessment.find_by(student: @student, faculty: current_faculty)
  
      if @assessment.nil?
        flash[:error] = "Assessment not found."
        redirect_to faculty_dashboard_path
      end
    end

    def change_password
    end
    
    def update_password
      @faculty = current_faculty
    
      if @faculty&.authenticate(password_params[:current_password])
        if @faculty.update(password_params.except(:current_password))
          flash[:success] = "Password updated successfully."
          redirect_to faculty_dashboard_path
        else
          flash[:error] = "Failed to update password."
          render :change_password
        end
      else
        flash[:error] = "Invalid current password."
        render :change_password
      end
    end


    private

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this page.'
      redirect_to faculty_login_path
    end
  end

  # You can define the following methods in your ApplicationController or a separate helper module
  def log_in(faculty)
    session[:faculty_id] = faculty.id
  end

  def log_out
    session.delete(:faculty_id)
  end

  def logged_in?
    !current_faculty.nil?
  end

  def current_faculty
    @current_faculty ||= Faculty.find_by(id: session[:faculty_id]) if session[:faculty_id]
  end

  def assessment_params
    params.require(:assessment).permit(:public_comment, :rating, :eligible_for_reward, :private_comment)
  end

  def password_params
    params.require(:faculty).permit(:current_password, :password, :password_confirmation)
  end 
end

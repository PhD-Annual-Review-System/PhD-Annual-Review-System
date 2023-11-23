class StudentController < ApplicationController
    before_action :ensure_logged_in, only: [:edit_committee, :search_faculty, :add_to_committee, :view_assessments, :change_password, :update_password]

    def login
    end
    
    def authenticate
      flash.clear
      @student = Student.find_by(email_id: params[:student][:email_id])
      if @student && @student.authenticate(params[:student][:password])
        # Authentication successful. Store user information in the session.
        session[:student_id] = @student.id
        session[:email] = @student.email_id
        session[:name] = @student.first_name
        redirect_to student_dashboard_path # Redirect to the student's dashboard.
      else
        # Authentication failed. Show an error message and render the login form again.
        flash.now[:error] = 'Invalid Email or password.'
        render :login
      end
    end

    def new_signup
      @student = Student.new
    end

    def create_signup
      @student = Student.new(student_params)
      if @student.save
        # Registration successful. Redirect to the student's dashboard or login page.
        session[:student_id] = @student.id
        session[:email] = @student.email_id
        session[:name] = @student.first_name
        redirect_to student_dashboard_path
      else
        # Registration failed. Show an error message and render the signup form again.
        render :new_signup
      end
    end

    def logout
      session[:student_id] = nil  # Clear the student's session
      session[:email] = nil
      session[:name] = nil
      redirect_to student_login_path  # Redirect to the root page or login page
    end

    def edit_committee
      @committee_members = current_student.committees.includes(:faculty).order('role ASC')
    end    

    def search_faculty
      @results = Faculty.where('first_name LIKE ? AND last_name LIKE ?', "%#{params[:first_name]}%", "%#{params[:last_name]}%")

      # Redirect to edit committee page if the search results are empty
      if @results.empty?
        flash[:error] = "No faculty found with name #{params[:first_name]} #{params[:last_name]}."
        redirect_to edit_committee_student_path
      end
    end

    def add_to_committee
      # Check if the faculty is already in the student's committee
      existing_member = current_student.committees.find_by(faculty_id: params[:faculty_id])
      
      if existing_member
        flash[:error] = "#{params[:first_name]} #{params[:last_name]} is already in your committee."
      else
        current_student.committees.create(faculty_id: params[:faculty_id], role: 'Member')
        flash[:success] = "#{params[:first_name]} #{params[:last_name]} added to committee!"
      end
    
      redirect_to edit_committee_student_path
    end

    def set_as_chair
      member = current_student.committees.find_by(faculty_id: params[:id])
      
      # Reset any existing chair to a normal member
      current_student.committees.where(role: 'Chair').update_all(role: 'Member')
    
      # Set the selected member as the chair
      member.update(role: 'Chair')
      
      flash[:success] = "#{member.faculty.first_name} #{member.faculty.last_name} is now set as the committee chair."
      redirect_to edit_committee_student_path
    end

    def return_to_member
      committee = Committee.find(params[:id])
      if committee.update(role: 'Member')
        flash[:success] = "Role changed back to Member."
      else
        flash[:error] = "Failed to change the role."
      end
      redirect_to edit_committee_student_path
    end

    # def view_assessments
    #   @assessments = current_student.assessments.select(:public_comment, :rating, :eligible_for_reward)
    # end

    def view_assessments
      @assessments = current_student.assessments
                       .select(:public_comment, :rating, :eligible_for_reward, :faculty_id)
                       .includes(:faculty)
    end

    def change_password
    end
    
    def update_password
      @student = current_student
    
      if @student&.authenticate(password_params[:current_password])
        if @student.update(password_params.except(:current_password))
          flash[:success] = "Password updated successfully."
          redirect_to student_dashboard_path
        else
          flash[:error] = "Failed to update password."
          render :change_password
        end
      else
        flash[:error] = "Invalid current password."
        render :change_password
      end
    end

    def view_submission
      @student = current_student
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
    
    private
    def student_params
      params.require(:student).permit(:first_name, :last_name, :UIN, :email_id, :password, :password_confirmation)
    end

    def current_student
      @current_student ||= Student.find(session[:student_id]) if session[:student_id]
    end

    def ensure_logged_in
      unless current_student
        flash[:alert] = "Please log in to continue."
        redirect_to student_login_path
      end
    end

    def password_params
      params.require(:student).permit(:current_password, :password, :password_confirmation)
    end    

    helper_method :current_student
end

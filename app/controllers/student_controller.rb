class StudentController < ApplicationController
    before_action :ensure_logged_in, only: [:edit_committee, :search_faculty, :add_to_committee]

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
      # Logic to fetch the student's committee or initialize a new one if needed.
    end

    def search_faculty
      @results = Faculty.where('first_name LIKE ? AND last_name LIKE ?', "%#{params[:first_name]}%", "%#{params[:last_name]}%")
    end

    def add_to_committee
      # Check if the faculty is already in the student's committee
      existing_member = current_student.committees.find_by(faculty_id: params[:faculty_id])
      
      if existing_member
        flash[:error] = "This faculty member is already in your committee."
      else
        current_student.committees.create(faculty_id: params[:faculty_id], role: 'Member')
        flash[:success] = "Faculty member added to committee!"
      end
    
      redirect_to edit_committee_student_path
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

    helper_method :current_student
end

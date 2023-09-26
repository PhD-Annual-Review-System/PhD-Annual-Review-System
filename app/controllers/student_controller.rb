class StudentController < ApplicationController
  
    def login
    end
    
    def authenticate
      @student = Student.find_by(email_id: params[:student][:email_id])
      if @student && @student.authenticate(params[:student][:password])
        # Authentication successful. Store user information in the session.
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
        session[:email] = @student.email_id
        session[:name] = @student.first_name
        redirect_to student_dashboard_path
      else
        # Registration failed. Show an error message and render the signup form again.
        render :new_signup
      end
    end

  
    private
    def student_params
      params.require(:student).permit(:first_name, :last_name, :UIN, :email_id, :password, :password_confirmation)
    end
end

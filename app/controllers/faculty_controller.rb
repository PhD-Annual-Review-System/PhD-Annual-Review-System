class FacultyController < ApplicationController
    def login
      end
    
    def authenticate
      @faculty = Faculty.find_by(email_id: params[:faculty][:email_id])
      if @faculty && @faculty.authenticate(params[:faculty][:password])
        # Authentication successful. Store user information in the session.
        session[:email] = @faculty.email_id
        session[:name] = @faculty.first_name
        redirect_to faculty_dashboard_path # Redirect to the faculty's dashboard.
      else
        # Authentication failed. Show an error message and render the login form again.
        flash.now[:error] = 'Invalid Email or password.'
        render :login
      end
    end


    def logout
      session[:email] = nil  # Clear the student's session
      session[:name] = nil
      redirect_to faculty_login_path  # Redirect to the root page or login page
    end
end

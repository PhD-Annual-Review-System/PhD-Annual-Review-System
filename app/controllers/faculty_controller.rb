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
end

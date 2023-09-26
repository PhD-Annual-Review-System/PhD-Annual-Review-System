class AdminController < ApplicationController
    def login
        # Handle the login logic for students here.
      end
    def authenticate
      @admin = Admin.find_by(email_id: params[:admin][:email_id])
      if @admin && @admin.authenticate(params[:admin][:password])
        # Authentication successful. Store user information in the session.
        session[:email] = @admin.email_id
        session[:name] = @admin.first_name
        redirect_to admin_dashboard_path # Redirect to the admin's dashboard.
      else
        # Authentication failed. Show an error message and render the login form again.
        flash.now[:error] = 'Invalid Email or password.'
        render :login
      end
    end
end

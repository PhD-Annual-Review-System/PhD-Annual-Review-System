class AdminController < ApplicationController
  before_action :ensure_logged_in, only: [:dashboard]

    def login
        # Handle the login logic for students here.
      end
    def authenticate
      @admin = Admin.find_by(email_id: params[:admin][:email_id])
      if @admin && @admin.authenticate(params[:admin][:password])
        # Authentication successful. Store user information in the session.
        session[:email] = @admin.email_id
        session[:name] = @admin.first_name
        session[:admin_id] = @admin.id
        redirect_to admin_dashboard_path # Redirect to the admin's dashboard.
      else
        # Authentication failed. Show an error message and render the login form again.
        flash.now[:error] = 'Invalid Email or password.'
        render :login
      end
    end

    def logout
      session[:email] = nil  # Clear the student's session
      session[:name] = nil
      redirect_to admin_login_path  # Redirect to the root page or login page
    end

    def current_admin
      @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
    end

    def ensure_logged_in
      unless current_admin
        flash[:alert] = "Please log in to continue."
        redirect_to admin_login_path
      end
    end
end

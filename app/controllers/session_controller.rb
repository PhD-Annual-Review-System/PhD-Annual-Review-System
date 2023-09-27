class SessionsController < ApplicationController
    def create
      user_data = request.env['omniauth.auth']
      session[:user] = user_data.info
      redirect_to root_path
    end
  
    def destroy
      session[:user] = nil
      redirect_to root_path
    end
end
  
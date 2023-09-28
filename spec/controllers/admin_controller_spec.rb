# spec/controllers/student_controller_spec.rb
require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  describe 'GET #logout' do
    it 'logs out the admin and redirects to the root page' do
      admin = create(:admin)
      session[:email] = admin.email_id
      session[:name] = admin.first_name
      get :logout
      expect(session[:email]).to be_nil 
      expect(session[:name]).to be_nil
      expect(response).to redirect_to(admin_login_path)
    end
  end

  describe 'POST #authenticate' do
  let!(:admin) { create(:admin, first_name: 'test', last_name: 'test', email_id: 'test1@tamu.edu', password: 'password', password_confirmation: 'password') }

  it 'logs in a student with valid credentials' do
    post :authenticate, params: { admin: { email_id: 'test1@tamu.edu', password: 'password' } }
    expect(session[:email]).to eq(admin.email_id)
    expect(response).to redirect_to(admin_dashboard_path)
  end

  it 'renders the login page with invalid credentials' do
    post :authenticate, params: { admin: { email_id: 'test1@tamu.edu', password: 'wrong_password' } }
    expect(session[:email]).to be_nil
    expect(response).to render_template(:login)
    expect(flash.now[:error]).to eq('Invalid Email or password.')
  end
end
end

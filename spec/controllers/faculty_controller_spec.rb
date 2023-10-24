# spec/controllers/faculty_controller_spec.rb
require 'rails_helper'

RSpec.describe FacultyController, type: :controller do
  
  describe 'GET #logout' do
    it 'logs out the faculty and redirects to the root page' do
      faculty = create(:faculty)
      session[:faculty_id] = faculty.id
      get :logout
      expect(session[:faculty_id]).to be_nil 
      expect(response).to redirect_to(faculty_login_path)
    end
  end

  describe 'POST #authenticate' do
  let!(:faculty) { create(:faculty, first_name: 'test', last_name: 'test', email_id: 'test1@tamu.edu', password: 'password', password_confirmation: 'password') }

  it 'logs in a faculty with valid credentials' do
    post :authenticate, params: { faculty: { email_id: 'test1@tamu.edu', password: 'password', id: 1 } }
    expect(session[:faculty_id]).to eq(faculty.id)
    expect(response).to redirect_to(faculty_dashboard_path)
  end

  it 'renders the login page with invalid credentials' do
    post :authenticate, params: { faculty: { email_id: 'test1@tamu.edu', password: 'wrong_password'} }
    expect(session[:faculty_id]).to be_nil
    expect(response).to render_template(:login)
    expect(flash.now[:error]).to eq('Invalid Email or password.')
  end
end
end

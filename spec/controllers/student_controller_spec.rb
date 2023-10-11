# spec/controllers/student_controller_spec.rb
require 'rails_helper'

RSpec.describe StudentController, type: :controller do
  describe 'GET #new_signup' do
    it 'renders the new signup template' do
      get :new_signup
      expect(response).to render_template(:new_signup)
    end
  end

  describe 'GET #logout' do
    it 'logs out the student and redirects to the root page' do
      student = create(:student)
      session[:email] = student.email_id
      session[:name] = student.first_name
      get :logout
      expect(session[:email]).to be_nil 
      expect(session[:name]).to be_nil
      expect(response).to redirect_to(student_login_path)
    end
  end

  describe 'POST #create_signup' do
    context 'with valid parameters' do
      it 'creates a new student' do
        expect {
          post :create_signup, params: { student: attributes_for(:student) }
        }.to change(Student, :count).by(1)
      end

      it 'redirects to the dashboard' do
        post :create_signup, params: { student: attributes_for(:student) }
        expect(response).to redirect_to(student_dashboard_path)
      end
    end

    context 'with invalid parameters' do
      it 'renders the new signup template' do
        post :create_signup, params: { student: attributes_for(:student, email_id: nil) }
        expect(response).to render_template(:new_signup)
      end

      it 'does not create a new student' do
        expect {
          post :create_signup, params: { student: attributes_for(:student, email_id: nil) }
        }.not_to change(Student, :count)
      end
    end
  end

  describe 'POST #authenticate' do
  let!(:student) { create(:student, first_name: 'test', last_name: 'test', UIN: 12345, email_id: 'test1@tamu.edu', password: 'password', password_confirmation: 'password') }

  it 'logs in a student with valid credentials' do
    post :authenticate, params: { student: { email_id: 'test1@tamu.edu', password: 'password' } }
    expect(session[:email]).to eq(student.email_id)
    expect(response).to redirect_to(student_dashboard_path)
  end

  it 'renders the login page with invalid credentials' do
    post :authenticate, params: { student: { email_id: 'invalid_email@example.com', password: 'wrong_password' } }
    expect(session[:email]).to be_nil
    expect(response).to render_template(:login)
    expect(flash.now[:error]).to eq('Invalid Email or password.')
  end
end
end

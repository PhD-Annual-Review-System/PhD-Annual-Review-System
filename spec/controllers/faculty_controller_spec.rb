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

describe 'GET #dashboard' do
    context 'when the faculty is logged in' do
      it 'renders the faculty dashboard' do
        faculty = create(:faculty)
        session[:faculty_id] = faculty.id
        get :dashboard
        expect(response).to render_template(:dashboard)
      end
    end

    context 'when the faculty is not logged in' do
      it 'redirects to the login page' do
        get :dashboard
        expect(response).to redirect_to(faculty_login_path)
      end
    end
  end

  describe 'GET #review_student' do
    it 'renders the review_student page' do
      faculty = create(:faculty)
      student = create(:student)
      session[:faculty_id] = faculty.id
      get :review_student, params: { id: student.id }
      expect(response).to render_template(:review_student)
    end
  end

  describe 'POST #save_assessment' do
    it 'saves a new assessment' do
      faculty = create(:faculty)
      student = create(:student)
      session[:faculty_id] = faculty.id
      assessment_params = { public_comment: 'Good work', rating: 'Satisfactory' }
      post :save_assessment, params: { id: student.id, assessment: assessment_params }
      expect(response).to redirect_to(faculty_dashboard_path)
      expect(flash[:success]).to eq('Assessment saved successfully.')
    end

    it 'updates an existing assessment' do
      faculty = create(:faculty)
      student = create(:student)
      create(:assessment, student: student, faculty: faculty)
      session[:faculty_id] = faculty.id
      assessment_params = { public_comment: 'Updated comment', rating: 'Satisfactory' }
      post :save_assessment, params: { id: student.id, assessment: assessment_params }
      expect(response).to redirect_to(faculty_dashboard_path)
      expect(flash[:success]).to eq('Assessment saved successfully.')
    end

    it 'fails to save assessment with invalid data' do
      faculty = create(:faculty)
      student = create(:student)
      session[:faculty_id] = faculty.id
      assessment_params = { public_comment: 'Invalid comment' } # Missing required data
      post :save_assessment, params: { id: student.id, assessment: assessment_params }
      expect(response).to redirect_to(faculty_dashboard_path)
      expect(flash[:error]).to eq('Failed to save assessment.')
    end
  end

  describe 'GET #view_assessment' do
    it 'renders the view_assessment page' do
      faculty = create(:faculty)
      student = create(:student)
      create(:assessment, student: student, faculty: faculty)
      session[:faculty_id] = faculty.id
      get :view_assessment, params: { id: student.id }
      expect(response).to render_template(:view_assessment)
    end

    it 'redirects to the faculty dashboard if assessment is not found' do
      faculty = create(:faculty)
      student = create(:student)
      session[:faculty_id] = faculty.id
      get :view_assessment, params: { id: student.id }
      expect(response).to redirect_to(faculty_dashboard_path)
      expect(flash[:error]).to eq('Assessment not found.')
    end
  end


end

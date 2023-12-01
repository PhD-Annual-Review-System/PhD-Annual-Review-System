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
      student_document = instance_double(StudentDocument, phd_start_date: 'Fall 2023')
      allow(StudentDocument).to receive(:find_by).with(email_id: student.email_id).and_return(student_document)
      session[:faculty_id] = faculty.id
      assessment_params = { public_comment: 'Good work', rating: 'Satisfactory' }
      post :save_assessment, params: { id: student.id, assessment: assessment_params }
      expect(response).to redirect_to(faculty_dashboard_path)
      expect(flash[:success]).to eq('Assessment saved successfully.')
    end

    it 'updates an existing assessment' do
      faculty = create(:faculty)
      student = create(:student)
      student_document = instance_double(StudentDocument, phd_start_date: 'Fall 2023')
      allow(StudentDocument).to receive(:find_by).with(email_id: student.email_id).and_return(student_document)
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
      student_document = instance_double(StudentDocument, phd_start_date: 'Fall 2023')
      allow(StudentDocument).to receive(:find_by).with(email_id: student.email_id).and_return(student_document)
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
  describe 'PATCH #update_password' do
  let(:faculty) { create(:faculty, password: 'password') }

  context 'when logged in' do
    before { allow(controller).to receive(:current_faculty).and_return(faculty) }

    context 'with valid params' do
      let(:valid_params) do
        {
          current_password: 'password',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'updates the password and redirects to the dashboard' do
        patch :update_password, params: { faculty: valid_params }
        expect(response).to redirect_to(faculty_dashboard_path)
        expect(flash[:success]).to be_present
      end
    end

    context 'with invalid current password' do
      let(:invalid_params) do
        {
          current_password: 'wrong_password',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'renders the change_password template with an error flash message' do
        patch :update_password, params: { faculty: invalid_params }
        expect(response).to render_template(:change_password)
        expect(flash[:error]).to be_present
      end
    end

    context 'with other update failures' do
      let(:error_params) do
        {
          current_password: 'password',
          password: 'new_password',
          password_confirmation: 'different_password'
        }
      end

      it 'renders the change_password template with an error flash message' do
        patch :update_password, params: { faculty: error_params }
        expect(response).to render_template(:change_password)
        expect(flash[:error]).to be_present
      end
    end
  end
  end 
end

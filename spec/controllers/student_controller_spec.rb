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
    @shared_email = 'test1@tamu.edu'
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

  describe '#ensure_logged_in' do
    let(:student) { create(:student, email_id: 'student_test@tamu.edu', password: 'password', password_confirmation: 'password') }

    context "when not logged in" do
      it "redirects to the login page with an alert" do
        get :edit_committee

        expect(response).to redirect_to(student_login_path)
        expect(flash[:alert]).to eq("Please log in to continue.")
      end
    end

    context "when logged in" do
      before do
        session[:student_id] = student.id
      end

      it "allows access to the action" do
        get :edit_committee

        expect(response).to_not redirect_to(student_login_path)
      end
    end
  end

  describe 'GET #edit_committee' do
    let(:faculty) { create(:faculty) }
    
    before do
      student = create(:student, email_id: 'edit_committee_test@tamu.edu', password: 'password', password_confirmation: 'password')
      create(:committee, student: student, faculty: faculty) 
      session[:student_id] = student.id
      get :edit_committee
    end
    
    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'sets the @committee_members variable' do
      expect(assigns(:committee_members)).to eq(Committee.all.to_a)
    end
  end

  describe 'POST #add_to_committee' do
    let(:student) { create(:student) }
    let(:faculty) { create(:faculty) }

    before do
      session[:student_id] = student.id
    end

    it 'adds a faculty member to the committee' do
      expect {
        post :add_to_committee, params: { faculty_id: faculty.id }
      }.to change(student.committees, :count).by(1)
    end

    it 'displays an error message if the faculty is already in the committee' do
      create(:committee, student: student, faculty: faculty)

      post :add_to_committee, params: { faculty_id: faculty.id }

      expect(flash[:error]).to eq('  is already in your committee.')
    end
  end

  describe 'GET #search_faculty' do
    let!(:faculty1) { create(:faculty, first_name: 'Prof1', last_name: 'Test1') }
    let!(:faculty2) { create(:faculty, first_name: 'Prof2', last_name: 'Test2') }
    
    before do
      student = create(:student, email_id: 'search_faculty_test@tamu.edu', password: 'password', password_confirmation: 'password')
      session[:student_id] = student.id
      get :search_faculty, params: { first_name: 'Prof1', last_name: 'Test1' }
    end

    it 'returns faculties matching the query' do
      expect(assigns(:results)).to eq([faculty1])
    end

    it 'does not return faculties not matching the query' do
      expect(assigns(:results)).not_to include(faculty2)
    end

    it 'redirects to edit_committee_student_path when no faculties match the query' do
      get :search_faculty, params: { first_name: 'NonExistentFirst', last_name: 'NonExistentLast' }
      
      # Expectations
      expect(response).to redirect_to(edit_committee_student_path)
      expect(flash[:error]).to eq("No faculty found with name NonExistentFirst NonExistentLast.")
    end
  end

  describe '#set_as_chair' do
    let(:student) { create(:student, email_id: 'student_test@tamu.edu', password: 'password', password_confirmation: 'password') }
    let(:faculty1) { create(:faculty, first_name: 'Faculty', last_name: 'One') }
    let(:faculty2) { create(:faculty, first_name: 'Faculty', last_name: 'Two') }

    let!(:committee1) { create(:committee, student: student, faculty: faculty1) } # Using let! to ensure it gets created before each example
    let!(:committee2) { create(:committee, student: student, faculty: faculty2) } 

    before do
      session[:student_id] = student.id
    end

    it 'sets a member as the chair if no chair exists' do
      post :set_as_chair, params: { id: faculty1.id }

      committee1.reload
      expect(committee1.role).to eq('Chair')
      expect(flash[:success]).to eq("#{faculty1.first_name} #{faculty1.last_name} is now set as the committee chair.")
    end

    it 'demotes the current chair when a new chair is set' do
      # Making faculty1 the chair via the committee1 association
      committee1.update(role: 'Chair')

      post :set_as_chair, params: { id: faculty2.id }

      committee1.reload
      committee2.reload
      expect(committee1.role).to eq('Member')
      expect(committee2.role).to eq('Chair')
      expect(flash[:success]).to eq("#{faculty2.first_name} #{faculty2.last_name} is now set as the committee chair.")
    end
  end

  describe '#return_to_member' do
    let(:student) { create(:student, email_id: 'student_test@tamu.edu', password: 'password', password_confirmation: 'password') }
    let(:faculty1) { create(:faculty, first_name: 'Faculty', last_name: 'One') }
    let(:faculty2) { create(:faculty, first_name: 'Faculty', last_name: 'Two') }

    let!(:committee1) { create(:committee, student: student, faculty: faculty1, role: 'Chair') } 
    let!(:committee2) { create(:committee, student: student, faculty: faculty2, role: 'Member') } 

    before do
      session[:student_id] = student.id
    end

    it 'changes a chair back to a member' do
      post :return_to_member, params: { id: committee1.id } 

      committee1.reload
      expect(committee1.role).to eq('Member')
      expect(flash[:success]).to eq("Role changed back to Member.")
    end

    it 'sets an error flash message when the role update fails' do
      allow_any_instance_of(Committee).to receive(:update).and_return(false)
      post :return_to_member, params: { id: committee1.id }
    
      expect(flash[:error]).to eq("Failed to change the role.")
    end
  end

  describe 'GET #view_assessments' do
    let(:student) { create(:student, email_id: 'student@tamu.edu', password: 'password', password_confirmation: 'password') }
    let(:faculty1) { create(:faculty, first_name: 'Prof1', last_name: 'Test1') }
    let(:faculty2) { create(:faculty, first_name: 'Prof2', last_name: 'Test2') }
    let!(:assessments) do
      [
        create(:assessment, student: student, faculty: faculty1, public_comment: 'Great Job!', rating: 5, eligible_for_reward: true),
        create(:assessment, student: student, faculty: faculty2, public_comment: 'Needs Improvement', rating: 3, eligible_for_reward: false)
      ]
    end

    # let!(:assessments) { create_list(:assessment, 2, student: student) }
    # puts Assessment.all.to_a # This should print out the created assessments

    before do
      session[:student_id] = student.id
      get :view_assessments, params: { id: student.id }
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end

    it 'only includes the specified attributes for each assessment' do
      assigned_assessments = assigns(:assessments)
      assessments.each_with_index do |assessment, index|
        expect(assigned_assessments[index].faculty.first_name).to eq(assessment.faculty.first_name)
        expect(assigned_assessments[index].faculty.last_name).to eq(assessment.faculty.last_name)
        expect(assigned_assessments[index].public_comment).to eq(assessment.public_comment)
        expect(assigned_assessments[index].rating).to eq(assessment.rating)
        expect(assigned_assessments[index].eligible_for_reward).to eq(assessment.eligible_for_reward)
        expect(assigned_assessments[index].attributes.keys).to contain_exactly('public_comment', 'rating', 'eligible_for_reward', 'id', 'faculty_id')
      end
    end
  end

  describe 'PATCH #update_password' do
  let(:student) { create(:student, password: 'password') }

  context 'when logged in' do
    before { allow(controller).to receive(:current_student).and_return(student) }

    context 'with valid params' do
      let(:valid_params) do
        {
          current_password: 'password',
          password: 'new_password',
          password_confirmation: 'new_password'
        }
      end

      it 'updates the password and redirects to the dashboard' do
        patch :update_password, params: { student: valid_params }
        expect(response).to redirect_to(student_dashboard_path)
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
        patch :update_password, params: { student: invalid_params }
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
        patch :update_password, params: { student: error_params }
        expect(response).to render_template(:change_password)
        expect(flash[:error]).to be_present
      end
    end
  end

    context 'when not logged in' do
      it 'redirects to the login page' do
        patch :update_password
        expect(response).to redirect_to(student_login_path)
      end
      end
  end 
end

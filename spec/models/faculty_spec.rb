# spec/models/admin_spec.rb

require 'rails_helper'

RSpec.describe Faculty, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      faculty = build(:faculty, password: 'password', password_confirmation: 'password')
      expect(faculty).to be_valid
    end

    it 'is invalid without a password' do
      faculty = build(:faculty, password: nil, password_confirmation: 'password')
      expect(faculty).to be_invalid
      expect(faculty.errors[:password]).to include("can't be blank")
    end

    it 'is invalid with a short password' do
      faculty = build(:faculty, password: 'short', password_confirmation: 'short')
      expect(faculty).to be_invalid
      expect(faculty.errors[:password]).to include('is too short (minimum is 8 characters)')
    end

    it 'is invalid with mismatched password confirmation' do
      faculty = build(:faculty, password: 'password', password_confirmation: 'different_password')
      expect(faculty).to be_invalid
      expect(faculty.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'is invalid with an email not ending with @tamu.edu' do
      faculty = build(:faculty, email_id: 'invalid_email@example.com', password: 'password', password_confirmation: 'password')
      expect(faculty).to be_invalid
      expect(faculty.errors[:email_id]).to include('must end with @tamu.edu')
    end
  end

  context 'authentication' do
    let!(:faculty) { create(:faculty, password: 'password') }

    it 'returns the faculty when authentication is successful' do
      authenticated_faculty = Faculty.find_by(email_id: faculty.email_id).try(:authenticate, 'password')
      expect(authenticated_faculty).to eq(faculty)
    end

    it 'returns false when authentication fails' do
      authenticated_faculty = Faculty.find_by(email_id: faculty.email_id).try(:authenticate, 'wrong_password')
      expect(authenticated_faculty).to be_falsey
    end
  end
end
# spec/models/admin_spec.rb

require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      admin = build(:admin, password: 'password', password_confirmation: 'password')
      expect(admin).to be_valid
    end

    it 'is invalid without a password' do
      admin = build(:admin, password: nil, password_confirmation: 'password')
      expect(admin).to be_invalid
      expect(admin.errors[:password]).to include("can't be blank")
    end

    it 'is invalid with a short password' do
      admin = build(:admin, password: 'short', password_confirmation: 'short')
      expect(admin).to be_invalid
      expect(admin.errors[:password]).to include('is too short (minimum is 8 characters)')
    end

    it 'is invalid with mismatched password confirmation' do
      admin = build(:admin, password: 'password', password_confirmation: 'different_password')
      expect(admin).to be_invalid
      expect(admin.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'is invalid with an email not ending with @tamu.edu' do
      admin = build(:admin, email_id: 'invalid_email@example.com', password: 'password', password_confirmation: 'password')
      expect(admin).to be_invalid
      expect(admin.errors[:email_id]).to include('must end with @tamu.edu')
    end
  end

  context 'authentication' do
    let!(:admin) { create(:admin, password: 'password') }

    it 'returns the admin when authentication is successful' do
      authenticated_admin = Admin.find_by(email_id: admin.email_id).try(:authenticate, 'password')
      expect(authenticated_admin).to eq(admin)
    end

    it 'returns false when authentication fails' do
      authenticated_admin = Admin.find_by(email_id: admin.email_id).try(:authenticate, 'wrong_password')
      expect(authenticated_admin).to be_falsey
    end
  end
end
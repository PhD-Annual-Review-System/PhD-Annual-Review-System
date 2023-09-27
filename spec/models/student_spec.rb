require 'rails_helper'

RSpec.describe Student, type: :model do
  describe 'Validations' do
    it 'validates presence of email_id' do
      student = Student.new(password: 'password', password_confirmation: 'password')
      expect(student).not_to be_valid
      expect(student.errors[:email_id]).to include("can't be blank")
    end

    it 'validates presence of password' do
        student = Student.new(email_id: 'test@example.com', password_confirmation: 'password')
        expect(student).not_to be_valid
        expect(student.errors[:password]).to include("can't be blank")
    end

    it 'validates that password and password_confirmation match' do
        student = Student.new(email_id: 'test@example.com', password: 'password', password_confirmation: 'different_password')
        expect(student).not_to be_valid
        expect(student.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'validates email_id format' do
        student = Student.new(email_id: 'invalid_email', password: 'password', password_confirmation: 'password')
        expect(student).not_to be_valid
        expect(student.errors[:email_id]).to include('must end with @tamu.edu')
    end


end
end
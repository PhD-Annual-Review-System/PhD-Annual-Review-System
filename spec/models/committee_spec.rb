# spec/models/committee_spec.rb
require 'rails_helper'

RSpec.describe Committee, type: :model do
    describe 'associations' do
      it 'belongs to a student' do
        student = Student.create(email_id: 'test@tamu.edu', password: 'password123', password_confirmation: 'password123')
        committee = Committee.new(student: student)
        expect(committee.student).to eq(student)
      end
  
      it 'belongs to a faculty' do
        faculty = Faculty.create(email_id: 'faculty@tamu.edu', password: 'password123', password_confirmation: 'password123')
        committee = Committee.new(faculty: faculty)
        expect(committee.faculty).to eq(faculty)
      end
    end
  
    describe 'validations' do
        it 'validates presence of role' do
            student = Student.create(email_id: 'test@example.com', password: 'password', password_confirmation: 'password')
            faculty = Faculty.create(email_id: 'faculty@example.com', password: 'password', password_confirmation: 'password')
            
            committee = Committee.new(student: student, faculty: faculty, role: nil)

            expect(committee.valid?).to be_falsey
            expect(committee.errors[:role]).to include("can't be blank")
        end
    end
  end

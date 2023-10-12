require 'rails_helper'

RSpec.describe StudentDocumentsController, type: :controller do
  
  before do
    if Student.where(email_id: 'newstudent1@tamu.edu').empty?
       Student.create(first_name: 'New', last_name: 'Student1', UIN: '1234', email_id: 'newstudent1@tamu.edu', :password => '12345678')
    end
  end
  
  describe 'PATCH #update' do
    it 'updates resume of the current student' do
      # Create a student with the email ID 'newstudent1@tamu.edu' if they don't exist
      student = Student.find_or_initialize_by(email_id: 'newstudent1@tamu.edu')
      student_document = StudentDocument.find_or_initialize_by(email_id: 'newstudent1@tamu.edu')
  
      # Simulate uploading a new resume file (replace with actual file upload logic)
      new_resume = Rails.root.join('features', 'upload_files', 'sample_resume.pdf')
      student_document.save
      
      session[:email] = student_document.email_id
    
      patch :update,params: {student_document: { email_id: 'newstudent1@tamu.edu', resume_file: new_resume }}

      # Reload the student document from the database to get the updated record
      student_document.reload
      
      #expected resume file name
      resume_file_name = student_document.email_id.gsub!(/@tamu\.edu/, '_resume')

      # Expect that the resume has been updated (you may want to check the updated file's name or content)
      expect(student_document.resume_file).to eq(resume_file_name) 
    end

    it 'redirect to student document path when no resume is uploaded' do
        # Create a student with the email ID 'newstudent1@tamu.edu' if they don't exist
        student = Student.find_or_initialize_by(email_id: 'newstudent1@tamu.edu')
        student_document = StudentDocument.find_or_initialize_by(email_id: 'newstudent1@tamu.edu')
        student_document.save
        
        session[:email] = student_document.email_id
      
        patch :update,params: {student_document: { email_id: 'newstudent1@tamu.edu' }}
  
        # Reload the student document from the database to get the updated record
        student_document.reload
        
        # redirect
        expect(response).to redirect_to(student_documents_path)
      end

      it 'flashes error when no resume is uploaded' do
        # Create a student with the email ID 'newstudent1@tamu.edu' if they don't exist
        student = Student.find_or_initialize_by(email_id: 'newstudent1@tamu.edu')
        student_document = StudentDocument.find_or_initialize_by(email_id: 'newstudent1@tamu.edu')
        student_document.save
        
        session[:email] = student_document.email_id
      
        patch :update,params: {student_document: { email_id: 'newstudent1@tamu.edu' }}
  
        # Reload the student document from the database to get the updated record
        student_document.reload
        
        # Expect error
        expect(flash[:notice]).to eq('Error: Please select a file to upload!')
      end
  end
end

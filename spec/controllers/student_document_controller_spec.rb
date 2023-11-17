require 'rails_helper'

RSpec.describe StudentDocumentsController, type: :controller do
  
  before do
    if Student.where(email_id: 'newstudent1@tamu.edu').empty?
       Student.create(first_name: 'New', last_name: 'Student1', UIN: '1234', email_id: 'newstudent1@tamu.edu', :password => '12345678')
    end
  end
  
  let(:student_document) { create(:student_document, email_id: 'newstudent1@tamu.edu', 
                                                     resume_file: 'newstudent1_resume', 
                                                     resume_link: 'sample.pdf', 
                                                     phd_start_date: 'Fall 2023', 
                                                     milestones_passed: ['new milestone'], 
                                                     improvement_plan_present: 'No', 
                                                     improvement_plan_summary: 'NA', 
                                                     gpa: '3', 
                                                     support_in_last_sem: ['value'],
                                                     support_in_last_sem_description: ['desc'],
                                                     number_of_paper_submissions: '1',
                                                     number_of_papers_published: '1', 
                                                     report_link: 'sample.pdf', 
                                                     report_file: 'newstudent1_report')}
      
  describe 'PATCH #update' do
    it 'update details with valid fields' do
      
      # Simulate uploading a new resume file (replace with actual file upload logic)
      new_resume = Rails.root.join('features', 'upload_files', 'sample_resume.pdf')
      new_report = Rails.root.join('features', 'upload_files', 'sample_resume.pdf')
      session[:email] = student_document.email_id
      new_phd_start_date = 'Fall 2023'
      new_milestones_passed = ['new milestone']
      new_improvement_plan_present = 'No'
      new_improvement_plan_summary = 'NA'
      new_gpa = 3.0
      new_support_in_last_sem = ['value']
      new_support_in_last_sem_description = ['desc']
      new_number_of_paper_submissions = 1
      new_number_of_papers_published = 12
      resume_file_name = student_document.email_id.dup.gsub!(/@tamu\.edu/, '_resume')
      report_file_name = student_document.email_id.dup.gsub!(/@tamu\.edu/, '_report')
      patch :update, params: { id: student_document.id, student_document: { email_id: 'newstudent1@tamu.edu', 
                                                 resume_file: new_resume, 
                                                 report_file: new_report,
                                                 phd_start_date: new_phd_start_date, 
                                                 milestones_passed: new_milestones_passed, 
                                                 improvement_plan_present: new_improvement_plan_present,
                                                 improvement_plan_summary: new_improvement_plan_summary, 
                                                 gpa: new_gpa, 
                                                 support_in_last_sem: new_support_in_last_sem,
                                                 support_in_last_sem_description: ["desc"],
                                                 number_of_paper_submissions: new_number_of_paper_submissions, 
                                                 number_of_papers_published: new_number_of_papers_published
                            }}

      # Reload the student document from the database to get the updated record
      student_document.reload
 
      # Expected values
      expect(assigns(:student_document).resume_file).to eq(resume_file_name)
      expect(assigns(:student_document).report_file).to eq(report_file_name)
      expect(assigns(:student_document).phd_start_date).to eq(new_phd_start_date)
      expect(assigns(:student_document).milestones_passed).to eq(new_milestones_passed)
      expect(assigns(:student_document).improvement_plan_present).to eq(new_improvement_plan_present)
      expect(assigns(:student_document).improvement_plan_summary).to eq(new_improvement_plan_summary)
      expect(assigns(:student_document).gpa).to eq(new_gpa)
      expect(assigns(:student_document).support_in_last_sem).to eq(new_support_in_last_sem)
      expect(assigns(:student_document).support_in_last_sem_description).to eq(new_support_in_last_sem_description)
      expect(assigns(:student_document).number_of_paper_submissions).to eq(new_number_of_paper_submissions)
      expect(assigns(:student_document).number_of_papers_published).to eq(new_number_of_papers_published)
      expect(flash[:notice]).to eq("Details have been submitted.")
      expect(response).to redirect_to(student_documents_path)
    end

    it 'update details with missing fields' do
        
        session[:email] = student_document.email_id
      
        patch :update,params: {student_document: { email_id: 'newstudent1@tamu.edu' }}
  
        # Reload the student document from the database to get the updated record
        student_document.reload
        
        # redirect
        expect(flash[:notice]).to eq("Errors while updating details.")
        expect(response).to redirect_to(student_documents_path)
      end

  end
end

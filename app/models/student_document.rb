class StudentDocument < ApplicationRecord
  belongs_to :student, optional: true

  # Validations
  validates :phd_start_date, presence: true
  validates :milestones_passed, presence: true
  validates :improvement_plan_present, presence: true
  validates :improvement_plan_summary, presence: true
  validates :gpa, presence: true
  validates :support_in_last_sem, presence: true
  validates :number_of_paper_submissions, presence: true
  validates :number_of_papers_published, presence:true
  validates :resume_file, presence:true
  validates :report_file, presence:true
  
end

class StudentDocument < ApplicationRecord
  belongs_to :student, optional: true
  serialize :milestones_passed, Array
  serialize :support_in_last_sem, Array
  serialize :support_in_last_sem_description, Array

  # Validations
  validates :phd_start_date, presence: true
  validates :milestones_passed, presence: true
  validates :improvement_plan_present, presence: true
  validates :improvement_plan_summary, presence: true, if: :improvement_plan_present_yes?
  validates :gpa, presence: true
  validates :support_in_last_sem, presence: true
  validates :support_in_last_sem_description, presence: true
  validates :number_of_paper_submissions, presence: true
  validates :number_of_papers_published, presence:true
  validates :resume_file, presence:true
  validates :report_file, presence:true

  validate :support_in_last_sem_descriptions_presence_if_checked

  def support_in_last_sem_descriptions_presence_if_checked
    support_in_last_sem.each do |support_option|
      if support_option != "None"
        index = support_in_last_sem.index(support_option)
        description = support_in_last_sem_description[index]
        if description.blank?
          errors.add(:support_in_last_sem_description, "can't be blank for '#{support_option}' support option")
        end
      end
    end

    if improvement_plan_present_yes? && improvement_plan_summary.blank?
      errors.add(:improvement_plan_summary, "can't be blank if improvement plan is present")
    elsif improvement_plan_present_no?
      self.improvement_plan_summary = nil
    end
  end
  
  private

  def improvement_plan_present_yes?
    improvement_plan_present == 'Yes'
  end

  def improvement_plan_present_no?
    improvement_plan_present == 'No'
  end
end

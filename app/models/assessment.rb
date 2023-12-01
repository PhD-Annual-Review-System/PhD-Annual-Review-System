# app/models/assessment.rb
class Assessment < ApplicationRecord
  belongs_to :student
  belongs_to :faculty
  has_many :student_documents, foreign_key: :email_id

  validates :rating, presence: true

  after_save :update_student_final_assessment

  def update_student_final_assessment
    student = self.student

    faculty_ids = Committee.where(student_id: student.id).pluck(:faculty_id)
    
    if faculty_ids.all? { |faculty_id| student.assessments.exists?(faculty_id: faculty_id) }
      assessment_ratings = student.assessments.pluck(:rating)
      student_awards = student.assessments.pluck(:eligible_for_reward)
      total_years = calculate_total_years(student.phd_start_date)
      
      completed_milestones = student.student_documents.map(&:milestones_passed).flatten.compact.uniq

      final_assessment = if assessment_ratings.include?("Unsatisfactory") || assessment_ratings.include?("Needs Improvement")
                           "Needs Faculty Review"
                         elsif total_years >= 4 && (!(completed_milestones.include?("Passed Prelim Exam") && completed_milestones.include?("Have Approved PhD Proposal")))
                           "Needs Faculty Review"
                         elsif total_years >= 5 && (!completed_milestones.include?("Defended Dissertation"))
                           "Needs Faculty Review"
                         elsif student_awards.any? { |award| award == true }
                           "Needs Faculty Review for award"
                         else
                           "Satisfactory"
                         end
      
      # Update the student's final assessment
      student.update(final_assessment: final_assessment)  
    end
  end
end

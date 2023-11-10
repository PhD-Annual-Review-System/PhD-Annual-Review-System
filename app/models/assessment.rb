class Assessment < ApplicationRecord
    belongs_to :student
    belongs_to :faculty

    validates :rating, presence: true

    after_save :update_final_assessment

  def update_final_assessment
    student = self.student
    Rails.logger.debug "This is a debug message"
    Rails.logger.debug student
    faculty_ids = Committee.where(student_id: student.id).pluck(:faculty_id)
    puts faculty_ids
    student.update(UIN: 52)
    if faculty_ids.all? { |faculty_id| student.assessments.exists?(faculty_id: faculty_id) }
      assessment_ratings = student.assessments.pluck(:rating)
      Rails.logger.debug 'assessment_ratings'
      Rails.logger.debug assessment_ratings
      if assessment_ratings.include?("Unsatisfactory")
        student.update_attribute(:final_assessment, "Unsatisfactory")

        Rails.logger.debug 'updated to unsatisfactory'
        Rails.logger.debug student.final_assessment
        Rails.logger.debug student.id
      elsif assessment_ratings.include?("Needs Improvement")
        student.update_attribute(:final_assessment, "Needs Improvement")
      else
        student.update_attribute(:final_assessment, "Satisfactory")
      end
    end
  end
end

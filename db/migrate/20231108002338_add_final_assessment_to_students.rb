class AddFinalAssessmentToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :final_assessment, :string
  end
end

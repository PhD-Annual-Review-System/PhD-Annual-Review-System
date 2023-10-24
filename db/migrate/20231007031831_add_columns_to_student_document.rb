class AddColumnsToStudentDocument < ActiveRecord::Migration[7.0]
  def change
    add_column :student_documents, :phd_start_date, :string
    add_column :student_documents, :milestones_passed, :text
    add_column :student_documents, :improvement_plan_present, :string
    add_column :student_documents, :improvement_plan_summary, :text
    add_column :student_documents, :gpa, :float
    add_column :student_documents, :support_in_last_sem, :text
    add_column :student_documents, :number_of_paper_submissions, :integer
    add_column :student_documents, :number_of_papers_published, :integer
  end
end

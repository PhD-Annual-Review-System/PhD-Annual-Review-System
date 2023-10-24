class AddReportfileToStudentDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :student_documents, :report_file, :binary
  end
end

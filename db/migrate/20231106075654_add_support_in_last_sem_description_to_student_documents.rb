class AddSupportInLastSemDescriptionToStudentDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :student_documents, :support_in_last_sem_description, :text
  end
end

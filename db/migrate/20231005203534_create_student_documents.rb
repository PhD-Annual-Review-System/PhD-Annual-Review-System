class CreateStudentDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :student_documents do |t|
      t.binary :resume_file
      t.string :resume_link
      t.string :email_id, null: false

      t.timestamps
    end
    add_foreign_key :student_documents, :students, column: :email_id, primary_key: :email_id
  end
end

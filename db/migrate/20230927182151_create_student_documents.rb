class CreateStudentDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :student_documents do |t|
      t.string :first_name
      t.string :last_name
      t.string :UIN
      t.boolean :resume_present
      t.string :link_to_pdf

      t.timestamps
    end
  end
end

class AddUniquenessToStudents < ActiveRecord::Migration[7.0]
  def change
    add_index :students, :email_id, unique: true
  end
end

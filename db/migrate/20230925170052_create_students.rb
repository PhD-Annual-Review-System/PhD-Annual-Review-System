class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :UIN
      t.string :email_id
      t.string :password

      t.timestamps
    end
  end
end

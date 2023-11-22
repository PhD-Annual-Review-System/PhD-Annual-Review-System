class RemovePasswordFromAdminsFacultiesStudents < ActiveRecord::Migration[7.0]
  def change
    remove_column :admins, :password, :string
    remove_column :faculties, :password, :string
    remove_column :students, :password, :string
  end
end

class AddRoleToCommittees < ActiveRecord::Migration[7.0]
  def change
    add_column :committees, :role, :string, default: 'Member'
  end
end

class CreateCommittees < ActiveRecord::Migration[7.0]
  def change
    create_table :committees do |t|
      t.references :student, null: false, foreign_key: true
      t.references :faculty, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end

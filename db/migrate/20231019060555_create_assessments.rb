class CreateAssessments < ActiveRecord::Migration[7.0]
  def change
    create_table :assessments do |t|
      t.references :student, foreign_key: true
      t.references :faculty, foreign_key: true
      t.text :public_comment
      t.string :rating
      t.boolean :eligible_for_reward, default: false
      t.text :private_comment
      t.timestamps
    end
  end
end

class CreateDocument < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string 'title'
      t.text 'description'
      t.string 'file_path'
      t.timestamps
    end
  end
end

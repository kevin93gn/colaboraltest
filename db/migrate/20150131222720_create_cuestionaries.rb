class CreateCuestionaries < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.boolean :completed
      t.boolean :visible
      t.integer :course_id

      t.timestamps null: false
    end
  end
end

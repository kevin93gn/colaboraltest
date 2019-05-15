class CreateCourseEvaluations < ActiveRecord::Migration
  def change
    create_table :course_evaluations do |t|
      t.integer :course_id
      t.string :name
      t.text :description
      t.integer :module_item_id
      t.text :file
      t.string :file_name
      t.text :file_description
      t.text :kind
      t.boolean :user_upload_expected

      t.timestamps null: false
    end
  end
end

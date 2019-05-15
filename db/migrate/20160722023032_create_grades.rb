class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.integer :course_id
      t.integer :course_evaluation_id
      t.integer :user_id
      t.float :grade
      t.string :user_file
      t.datetime :user_file_date_uploaded
      t.timestamps null: false
    end
  end
end

class CreateCourseUserEvaluations < ActiveRecord::Migration
  def change
    create_table :course_user_evaluations do |t|
      t.integer :grade
      t.text :text
      t.integer :course_id
      t.integer :user_id
      t.integer :course_evaluation_questionnaire_id
      t.integer :module_item_id
      t.boolean :sent

      t.timestamps null: false
    end
  end
end

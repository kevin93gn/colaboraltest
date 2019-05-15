class CreateCourseEvaluationQuestionnaires < ActiveRecord::Migration
  def change
    create_table :course_evaluation_questionnaires do |t|
      t.boolean :visible
      t.integer :course_id
      t.integer :evaluation_id
      t.timestamps null: false
    end
  end
end

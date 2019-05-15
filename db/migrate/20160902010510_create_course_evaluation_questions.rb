class CreateCourseEvaluationQuestions < ActiveRecord::Migration
  def change
    create_table :course_evaluation_questions do |t|
      t.string :text
      t.integer :position
      t.string :correct_answer
      t.integer :course_evaluation_questionnaire_id
      t.integer :course_evaluation_id
      t.timestamps null: false
    end
  end
end

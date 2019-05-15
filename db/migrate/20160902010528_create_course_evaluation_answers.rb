class CreateCourseEvaluationAnswers < ActiveRecord::Migration
  def change
    create_table :course_evaluation_answers do |t|
      t.string :answer
      t.integer :course_evaluation_id
      t.integer :evaluation_questionnaire_id
      t.integer :course_evaluation_question_id
      t.timestamps null: false
    end
  end
end

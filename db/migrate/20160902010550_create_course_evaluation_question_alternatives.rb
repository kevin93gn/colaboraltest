class CreateCourseEvaluationQuestionAlternatives < ActiveRecord::Migration
  def change
    create_table :course_evaluation_question_alternatives do |t|
      t.string :text
      t.integer :course_evaluation_question_id
      t.string :position
    end
  end
end

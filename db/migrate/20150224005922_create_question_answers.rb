class CreateQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :question_answers do |t|
      t.string :answer
      t.integer :user_evaluation_id
      t.integer :questionnaire_id
      t.integer :question_id

      t.timestamps null: false
    end
  end
end

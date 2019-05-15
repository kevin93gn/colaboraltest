class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :text
      t.integer :position
      t.string :correct_answer
      t.integer :questionnaire_id
      t.timestamps null: false
    end
  end
end

class CreateQuestionAlternatives < ActiveRecord::Migration
  def change
    create_table :question_alternatives do |t|
      t.string :text
      t.integer :question_id
      t.string :position
      t.timestamps null: false
    end
  end
end

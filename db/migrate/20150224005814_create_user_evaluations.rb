class CreateUserEvaluations < ActiveRecord::Migration
  def change
    create_table :user_evaluations do |t|
      t.integer :grade
      t.text :text
      t.integer :course_id
      t.integer :user_id
      t.integer :questionnaire_id

      t.timestamps null: false
    end
  end
end

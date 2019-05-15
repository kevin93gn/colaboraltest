class CreateCoacheeGoals < ActiveRecord::Migration
  def change
    create_table :coachee_goals do |t|
      t.boolean :completed
      t.integer :user_id
      t.integer :goal_id
      t.integer :coaching_id
      t.timestamps null: false
    end
  end
end

class CreateCoachingSessions < ActiveRecord::Migration
  def change
    create_table :coaching_sessions do |t|
      t.string :name
      t.date :date
      t.text :description
      t.string :file
      t.integer :coaching_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end

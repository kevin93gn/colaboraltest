class CreateCoachingActivities < ActiveRecord::Migration
  def change
    create_table :coaching_activities do |t|
      t.string :name
      t.text :text
      t.datetime :date
      t.integer :coaching_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end

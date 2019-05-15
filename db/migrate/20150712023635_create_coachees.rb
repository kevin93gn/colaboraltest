class CreateCoachees < ActiveRecord::Migration
  def change
    create_table :coachees do |t|
      t.integer :coaching_id, null: false
      t.integer :user_id, null: false
      t.boolean :completed, default: 'false'
      t.timestamps null: false
    end
  end
end

class CreateCoachings < ActiveRecord::Migration
  def change
    create_table :coachings do |t|
      t.string :name, null: false
      t.text :description
      t.integer :user_id, null: false
      t.integer :creator_id, null: false
      t.boolean :publish, null: false, default: false
      t.date :start
      t.date :end
      t.timestamps null: false
    end
  end
end

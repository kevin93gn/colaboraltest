class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.string :subfactor
      t.integer :percentage
      t.date :end_date
      t.text :description
      t.integer :coaching_id
      t.timestamps null: false
    end
  end
end

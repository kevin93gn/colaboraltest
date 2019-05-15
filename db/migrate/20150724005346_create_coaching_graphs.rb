class CreateCoachingGraphs < ActiveRecord::Migration
  def change
    create_table :coaching_graphs do |t|
      t.integer :coaching_id
      t.integer :user_id
      t.float :point_1
      t.float :point_2
      t.float :point_3
      t.float :point_4
      t.float :point_5
      t.float :point_6
      t.float :point_7
      t.float :point_8
      t.float :point_9
      t.float :point_10
      t.float :point_11

      t.integer :version

      t.timestamps null: false
    end
  end
end

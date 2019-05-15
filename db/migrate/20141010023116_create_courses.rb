class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.text :description
      t.integer :teacher_id, null: false
      t.integer :creator_id, null: false
      t.integer :hours
      t.string :category, null: false, default: 'eLearning'
      t.boolean :all_subscribed, null: false
      t.boolean :publish, null: false, default: false
      t.string :forum
      t.timestamps
    end
  end
end
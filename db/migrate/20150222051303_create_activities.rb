class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.text :text
      t.date :date
      t.integer :course_id
      t.timestamps null: false
    end
  end
end

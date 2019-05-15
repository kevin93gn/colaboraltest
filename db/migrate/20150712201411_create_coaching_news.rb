class CreateCoachingNews < ActiveRecord::Migration
  def change
    create_table :coaching_news do |t|
      t.string :title
      t.text :text
      t.integer :user_id
      t.integer :coaching_id
      t.timestamps null: false
    end
  end
end

class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :course_id, null: false
      t.integer :user_id, null: false
      t.boolean :completed, default: 'false'
      t.timestamps
    end
  end
end

class CreateModuleItemsUsers < ActiveRecord::Migration
  def change
    create_table :module_items_users do |t|
      t.boolean :status, null: false, default: false
      t.integer :user_id, null: false
      t.integer :module_item_id, null: false
      t.integer :course_id, null: false
      t.timestamps
    end
  end
end

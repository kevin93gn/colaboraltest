class AddViewsToModuleItemUsers < ActiveRecord::Migration
  def change
    change_table :module_items_users do |t|
      t.integer :visits
    end
  end
end

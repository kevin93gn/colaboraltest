class AddDataToModuleItems < ActiveRecord::Migration
  def change
    add_column :module_items, :data, :string
    add_column :module_items, :data_title, :string
    add_column :module_items, :data_description, :text
  end
end


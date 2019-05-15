class AddPresentationToModuleItems < ActiveRecord::Migration
  def change
    add_column :module_items, :presentation, :string

  end
end

class AddIsGlobalAndUserIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :is_global, :boolean
    add_column :goals, :user_id, :integer
  end
end

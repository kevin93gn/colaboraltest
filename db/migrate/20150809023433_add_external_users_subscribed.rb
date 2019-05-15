class AddExternalUsersSubscribed < ActiveRecord::Migration
  def change
    add_column :courses, :external_users_subscribed, :boolean, :default => false
  end
end

class AddContactToCoaching < ActiveRecord::Migration
  def up
    change_table :contacts do |t|
      t.references :user, index: true
    end
  end

  def down
    change_table :contacts do |t|
      t.remove_references :user, index: true
    end
  end
end

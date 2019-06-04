class AddContactToCoaching < ActiveRecord::Migration
  def up
    change_table :contacts do |t|
      t.references :coaching, index: true
    end
  end

  def down
    change_table :contacts do |t|
      t.remove_references :coaching, index: true
    end
  end
end

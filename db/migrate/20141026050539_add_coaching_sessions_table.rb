class AddCoachingSessionsTable < ActiveRecord::Migration
  def change
    create_table :coaching_session do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :coaching_session, :session_id, :unique => true
    add_index :coaching_session, :updated_at
  end
end

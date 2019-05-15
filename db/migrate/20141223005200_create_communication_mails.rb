class CreateCommunicationMails < ActiveRecord::Migration
  def change
    create_table :communication_mails do |t|
      t.integer :user_id
      t.string :subject
      t.text :content

      t.timestamps null: false
    end
  end
end

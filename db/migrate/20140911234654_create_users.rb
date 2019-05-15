class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false, default: ''
      t.string :last_name, null: false, default: ''
      t.string :rut, null: false, default: ''
      t.string :role, null: false, default: 'user'
      t.string :avatar_url
      t.string :client
      t.text :info
      t.timestamps
    end
  end

end

class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :enterprise
      t.string :job
      t.string :linkedin_url
      t.string :consultant
      t.string :category
      t.integer :status

      t.timestamps null: false
    end
  end
end

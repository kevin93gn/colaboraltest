class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :identifier

      t.timestamps
    end
  end
end

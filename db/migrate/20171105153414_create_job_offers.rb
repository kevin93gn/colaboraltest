class CreateJobOffers < ActiveRecord::Migration
  def change
    create_table :job_offers do |t|
      t.string :name
      t.string :url
      t.integer :coaching_id
      t.timestamps

    end
  end
end

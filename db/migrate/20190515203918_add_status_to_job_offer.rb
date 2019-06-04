class AddStatusToJobOffer < ActiveRecord::Migration
  def change
    add_column :job_offers, :status, :integer
    add_column :job_offers, :description, :string
    add_column :job_offers, :source, :string
  end
end

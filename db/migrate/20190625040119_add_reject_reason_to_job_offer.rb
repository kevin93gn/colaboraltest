class AddRejectReasonToJobOffer < ActiveRecord::Migration[5.0]
  def change
    add_column :job_offers, :reject_reason, :text
  end
end

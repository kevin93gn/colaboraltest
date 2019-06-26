class AddRejectReasonToContact < ActiveRecord::Migration[5.0]
  def change
    add_column :contacts, :reject_reason, :text
  end
end

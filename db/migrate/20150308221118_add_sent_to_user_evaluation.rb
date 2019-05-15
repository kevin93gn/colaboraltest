class AddSentToUserEvaluation < ActiveRecord::Migration
  def change
    add_column :user_evaluations, :sent, :boolean
  end
end


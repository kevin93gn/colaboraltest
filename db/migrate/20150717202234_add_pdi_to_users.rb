class AddPdiToUsers < ActiveRecord::Migration
  def change
    add_column :coachees, :pdi, :text

  end
end

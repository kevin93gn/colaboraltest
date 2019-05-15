class AddProfessionAndInstitutionToUser < ActiveRecord::Migration
  def change
    add_column :users, :institution, :string
    add_column :users, :profession, :string
  end
end

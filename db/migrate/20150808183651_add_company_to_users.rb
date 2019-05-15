class AddCompanyToUsers < ActiveRecord::Migration
  def change

    add_column :users, :phone, :string
    add_column :users, :mobile, :string

    add_column :users, :company_name, :string
    add_column :users, :company_rut, :string

    add_column :users, :company_region, :string
    add_column :users, :company_phone, :string
    add_column :users, :company_email, :string
    add_column :users, :company_address, :string
    add_column :users, :company_activity, :string
    add_column :users, :company_type, :string
    add_column :users, :external_user, :boolean, :default => false

  end
end

class AddImageToNews < ActiveRecord::Migration
  def change
    add_column :coaching_news, :image, :string
  end
end

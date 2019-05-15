class CreateModuleItems < ActiveRecord::Migration
  def change
    create_table :module_items do |t|
      t.string :title, null: false
      t.text :text
      t.integer :course_id, null: false
      t.integer :course_module_id, null: false
      t.string :media_url, null: false
      t.string :media_type, null: false
      t.integer :time_in_mins
      t.string :disqus_identifier, null: false
      t.integer :position, null: false


      t.timestamps
    end
  end
end

class CreateCourseModules < ActiveRecord::Migration
  def change
    create_table :course_modules do |t|
      t.string :name, null: false
      t.integer :position, null: false
      t.integer :course_id, null: false

      t.timestamps
    end
  end
end

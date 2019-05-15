class ModuleItemUserEvaluationFile < ActiveRecord::Migration
  def change
    add_column :course_evaluations, :evaluation_file, :string
    add_column :course_evaluations, :visible, :boolean
    add_column :module_items_users, :sent, :boolean, :default => false
    add_column :module_items_users, :evaluation_file, :string

  end
end

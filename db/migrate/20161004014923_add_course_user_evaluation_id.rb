class AddCourseUserEvaluationId < ActiveRecord::Migration
  def change
    add_column :module_items_users, :course_user_evaluation_id, :integer
    rename_column :course_evaluation_answers, :course_evaluation_id, :course_user_evaluation_id

  end
end

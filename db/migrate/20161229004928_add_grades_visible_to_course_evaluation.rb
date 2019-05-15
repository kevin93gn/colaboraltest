class AddGradesVisibleToCourseEvaluation < ActiveRecord::Migration
  def change
    add_column :course_evaluations, :grades_visible, :boolean, :default => false
  end
end

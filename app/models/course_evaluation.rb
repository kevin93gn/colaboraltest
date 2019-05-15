class CourseEvaluation < ActiveRecord::Base

  mount_uploader :evaluation_file, ItemData

  has_many :grades
  has_many :course_user_evaluations
  belongs_to :course
  belongs_to :module_item

  validates_presence_of :name
end

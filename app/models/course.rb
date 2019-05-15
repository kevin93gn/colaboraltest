class Course < ActiveRecord::Base
  has_many :course_modules
  has_many :module_items
  has_one :questionnaire
  has_many :activities
  has_many :user_evaluations

  mount_uploader :image , CourseImage


  validates_presence_of :name, :category, :teacher_id



end

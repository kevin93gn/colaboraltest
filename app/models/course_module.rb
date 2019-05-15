class CourseModule < ActiveRecord::Base
  belongs_to :course
  has_many :module_items

  validates_presence_of :name

  def last?
    self.position == CourseModule.where(:course_id => self.course_id).order('position ASC').last.position
  end
end

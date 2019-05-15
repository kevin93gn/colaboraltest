class ModuleItem < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_module
  has_one :course_evaluation
  mount_uploader :data, ItemData
  mount_uploader :presentation, ItemData

  validates_presence_of :media_type, :title

  def last?
    self.position == ModuleItem.where(:course_module_id => self.course_module_id, :course_id => self.course_id).order('position ASC').last.position
  end

end

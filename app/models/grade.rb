class Grade < ActiveRecord::Base

  belongs_to :course_evaluation
  belongs_to :user

  validates_presence_of :grade, :user_id
  validates :grade, :numericality => { :less_than_or_equal_to => 7, :greater_than_or_equal_to => 0  }
  validates_uniqueness_of :course_evaluation_id, scope: :user_id

end

class CourseUserEvaluation < ActiveRecord::Base
  has_many :course_evaluation_answers
  belongs_to :user
  belongs_to :course
  belongs_to :course_evaluation
end

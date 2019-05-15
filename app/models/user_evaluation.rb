class UserEvaluation < ActiveRecord::Base

  has_many :question_answers
  belongs_to :user
  belongs_to :course
end

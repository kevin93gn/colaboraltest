class CourseEvaluationQuestionnaire < ActiveRecord::Base

  belongs_to :course

  has_many :course_evaluation_questions
  accepts_nested_attributes_for :course_evaluation_questions

end

class CourseEvaluationQuestion < ActiveRecord::Base

  belongs_to :course_evaluation_questionnaire
  has_many :course_evaluation_question_alternatives
  accepts_nested_attributes_for :course_evaluation_question_alternatives
  validates_presence_of :text, :correct_answer

end

class CourseEvaluationQuestionAlternative < ActiveRecord::Base

  belongs_to :course_evaluation_question

  validates_presence_of :text

end

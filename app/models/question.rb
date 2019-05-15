class Question < ActiveRecord::Base

  belongs_to :questionnaire
  has_many :question_alternatives
  accepts_nested_attributes_for :question_alternatives

  validates_presence_of :text, :correct_answer


end

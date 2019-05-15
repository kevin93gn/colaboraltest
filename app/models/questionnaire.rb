class Questionnaire < ActiveRecord::Base

  belongs_to :course
  has_many :questions
  accepts_nested_attributes_for :questions


end

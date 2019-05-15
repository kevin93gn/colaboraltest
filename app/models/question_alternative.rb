class QuestionAlternative < ActiveRecord::Base
  belongs_to :question

  validates_presence_of :text

end

















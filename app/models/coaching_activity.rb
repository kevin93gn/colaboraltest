class CoachingActivity < ActiveRecord::Base

  belongs_to :coaching
  validates_presence_of :name

end

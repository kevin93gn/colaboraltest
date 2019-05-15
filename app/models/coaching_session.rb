class CoachingSession < ActiveRecord::Base

  mount_uploader :file , CoachingSessionFile

  belongs_to :coaching

  validates_presence_of :name

end

class Coachee < ActiveRecord::Base

  belongs_to :coaching
  belongs_to :user
  
end

class Coaching < ActiveRecord::Base
  belongs_to :user
  has_many :goals
  has_many :coaching_news
  has_many :sessions
  has_many :coaching_activities
  has_many :job_offers

  validates_presence_of :name

end

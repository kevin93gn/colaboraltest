class JobOffer < ActiveRecord::Base

  belongs_to :coaching
  belongs_to :user
  validates_presence_of :name, :url, :status
  validates :url, :format => URI::regexp(%w(http https))

end

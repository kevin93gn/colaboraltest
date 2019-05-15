class CoachingNews < ActiveRecord::Base

belongs_to :coaching
belongs_to :user

mount_uploader :image , NewsImage


end

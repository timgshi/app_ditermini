# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Photo < ActiveRecord::Base
  attr_accessible :filename, :user_id, :caption
  belongs_to :user

  validates :user_id, presence: true
  validates :filename, presence: true
  
  default_scope order: 'photos.created_at DESC'

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end

# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  caption    :string(255)      default("")
#

class Photo < ActiveRecord::Base
  acts_as_voteable

  attr_accessible :user_id, :caption, :image, :lat, :lng
 
  belongs_to :user

  validates :user_id, presence: true
  
  default_scope order: 'photos.created_at DESC'

  has_attached_file :image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>',
    feed: '320>'
  }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", 
          user_id: user.id)
  end
end

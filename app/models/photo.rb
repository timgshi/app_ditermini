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
  attr_accessible :filename, :user_id
  belongs_to :user

  validates :user_id, presence: true
  validates :filename, presence: true
  
  default_scope order: 'photos.created_at DESC'
end

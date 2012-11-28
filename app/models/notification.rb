# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  notifier_id :integer
#  notified_id :integer
#  message     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Notification < ActiveRecord::Base
  attr_accessible :notified_id, :notifier_id, :message

  belongs_to :notifier, class_name: "User"
  belongs_to :notified, class_name: "User"

  validates :notifier_id, presence: true
  validates :notified_id, presence: true

  default_scope order: 'notifications.created_at DESC'
end

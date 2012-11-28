# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  acts_as_voter
  attr_accessible :email, :name, :password, :password_confirmation, :phone_number
  #acts_as_voter

  # The following line is optional, and tracks karma (up votes) for photos this user has submitted.
  # Each photo has a submitter_id column that tracks the user who submitted it.
  # The option :weight value will be multiplied to any karma from that voteable model (defaults to 1).
  # You can track any voteable model.
  #has_karma(:photos, :as => :submitter, :weight => 0.5)

  has_secure_password

  has_many :photos, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name:  "Relationship", dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :notifications, foreign_key: "notifier_id", dependent: :destroy
  has_many :notified_users, through: :notifications, source: :notified
  has_many :reverse_notifications, foreign_key: "notified_id", class_name:  "Notification", dependent:   :destroy
  has_many :notifiers, through: :reverse_notifications, source: :notifier


  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_attached_file :avatar, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
  }

  def feed
    Photo.from_users_followed_by(self)
  end

  def following?(other_user)
    self.relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    self.relationships.find_by_followed_id(other_user.id).destroy
  end

  def notifiedme?(other_user)
    self.notifications.find_by_notifier_id(other_user.id)
  end

  def notify!(other_user, msg)
    self.notifications.create!(notified_id: other_user.id, message: msg)
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end

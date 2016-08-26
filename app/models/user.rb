class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged

  has_secure_password
  has_many :topics
  has_many :posts
  has_many :comments
  has_many :votes
  enum role: [:user, :moderator, :admin]

  mount_uploader :image, ImageUploader
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  before_save :update_slug

  def update_slug
    if username
      self.slug = username.gsub(" ", "-")
    end
  end
end

class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :comments
  belongs_to :topic

  mount_uploader :image, ImageUploader
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { maximum: 200 }, presence: true

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end

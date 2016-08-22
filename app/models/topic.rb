class Topic < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :posts

  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { maximum: 100 }, presence: true

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end

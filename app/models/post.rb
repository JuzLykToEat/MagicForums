class Post < ApplicationRecord
  has_many :comments
  belongs_to :topic

  mount_uploader :image, ImageUploader
  validates :title, length: { minimum: 5 }, presence: true
  validates :body, length: { maximum: 20 }, presence: true
end

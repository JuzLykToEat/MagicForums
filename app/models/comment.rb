class Comment < ApplicationRecord
  belongs_to :post

  mount_uploader :image, ImageUploader
  validates :body, length: { maximum: 20 }, presence: true
end

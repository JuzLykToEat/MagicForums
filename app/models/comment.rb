class Comment < ApplicationRecord
  belongs_to :post
  paginates_per 5

  mount_uploader :image, ImageUploader
  validates :body, length: { maximum: 200 }, presence: true
end

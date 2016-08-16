class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  paginates_per 5

  mount_uploader :image, ImageUploader
  validates :body, length: { maximum: 200 }, presence: true
end

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  has_many :votes
  paginates_per 5

  mount_uploader :image, ImageUploader
  validates :body, length: { maximum: 200 }, presence: true

  def total_likes
    votes.where(like: 1).count
  end

  def total_dislikes
    votes.where(like: -1).count
  end

end

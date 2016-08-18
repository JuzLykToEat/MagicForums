class RemoveDislikeFromVotes < ActiveRecord::Migration[5.0]
  def change
    remove_column :votes, :dislike
  end
end

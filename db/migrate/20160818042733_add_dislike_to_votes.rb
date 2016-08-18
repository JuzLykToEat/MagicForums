class AddDislikeToVotes < ActiveRecord::Migration[5.0]
  def change
    add_column :votes, :dislike, :integer
  end
end

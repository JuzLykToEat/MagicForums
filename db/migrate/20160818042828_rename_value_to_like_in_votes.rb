class RenameValueToLikeInVotes < ActiveRecord::Migration[5.0]
  def change
    rename_column :votes, :value, :like
  end
end

class RenameCommendToCommentInVotes < ActiveRecord::Migration[5.0]
  def change
    rename_column :votes, :commend_id, :comment_id
  end
end

class RemoveSlugFromTopicsPostsComments < ActiveRecord::Migration[5.0]
  def change
    remove_column :topics, :slug
    remove_column :posts, :slug
    remove_column :comments, :slug
  end
end

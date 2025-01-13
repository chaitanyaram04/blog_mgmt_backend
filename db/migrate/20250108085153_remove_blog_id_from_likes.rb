class RemoveBlogIdFromLikes < ActiveRecord::Migration[7.1]
  def change
    remove_column :likes, :blog_id, :bigint
  end
end

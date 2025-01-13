class AddIdDeletedAndStatusToBlogs < ActiveRecord::Migration[7.1]
  def change
    add_column :blogs, :id_deleted, :boolean
    add_column :blogs, :status, :string
  end
end

class RenameIdDeletedToIsDeletedInBlogs < ActiveRecord::Migration[7.1]
  def change
    rename_column :blogs, :id_deleted, :is_deleted
  end
end

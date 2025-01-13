class ChangeUsersIdToUserIdIn < ActiveRecord::Migration[7.1]
  def change
    rename_column :blogs, :users_id, :user_id
  end
end

class AddLikeableToLikes < ActiveRecord::Migration[7.1]
  def change
    add_reference :likes, :likeable, polymorphic: true, null: false
  end
end

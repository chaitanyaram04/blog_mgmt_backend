class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :updated_at, :user_name, :user_id, :likes

  def likes
    object.likes.count
  end
  def user_id
    object.user.id
  end
  def user_name
    object.user.user_name
  end
end

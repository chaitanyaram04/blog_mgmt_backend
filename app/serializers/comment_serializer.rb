class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :updated_at, :user_name, :user_id, :likes, :is_deleted, :blog_id

  def likes
    object.likes.count
  end
  def is_deleted
    object.blog.is_deleted
  end
  def user_id
    object.user.id
  end
  def user_name
    object.user.user_name
  end
  def blog_id
    object.blog.id
  end
end

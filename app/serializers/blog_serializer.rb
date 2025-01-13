class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at, :user_name, :user_id, :is_deleted, :user_liked, :likes_count

  # has_many :comments, serializer: CommentSerializer

  # class CommentSerializer < ActiveModel::Serializer
  #   attributes :id, :content, :user_name, :created_at, :user_id

  #   def user_id
  #     object.user.id
  #   end
  #   def user_name
  #     object.user.user_name
  #   end
  # end

  def likes_count
    object.likes.count
  end

  def user_id
    object.user.id
  end
  
  def user_liked
    object.likes.where(user: scope).exists?
  end
  def user_name
    object.user.user_name
  end
end

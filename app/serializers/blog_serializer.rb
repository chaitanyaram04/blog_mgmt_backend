class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :updated_at, :user_name, :user_id, :is_deleted, :user_liked, :likes_count, :comments_count, :created_at, :all_user_names

  has_many :likes, serializer: LikeSerializer

  def all_user_names
    object.likes.includes(:user).map { |like| like.user.user_name }
  end
  def comments_count
    object.comments.count
  end
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

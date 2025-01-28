class LikeSerializer < ActiveModel::Serializer
  attributes :id, :updated_at, :user_name, :all_user_names, :user_id

  def user_id
    object.user.id
  end
  def user_name
    object.user.user_name
  end

  def all_user_names
    return [] unless object.likeable && object.likeable.likes.present?
  
    object.likeable.likes.includes(:user).map { |like| like.user.user_name }
  end
  

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end

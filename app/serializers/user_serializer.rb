class UserSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :email, :role

  has_many :blogs
  has_many :likes
  has_many :comments
end

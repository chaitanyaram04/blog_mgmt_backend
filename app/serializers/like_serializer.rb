class LikeSerializer < ActiveModel::Serializer
  attributes :id,:updated_at

  belongs_to :user
  belongs_to :likeable, polymorphic: true
end

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  has_many :likes, as: :likeable
  validates :content, presence: true 
end

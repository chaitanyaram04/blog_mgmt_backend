class Blog < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable
  validates :title, presence: true
  validates :description, presence: true


  scope :active, -> { where(is_deleted: false,status: 'published') }
  scope :deleted, -> { where(is_deleted: true) }
  scope :drafted, -> { where(status: 'drafted', is_deleted:false) }
  scope :published, -> { where(status: 'published', is_deleted: false) }
  scope :search_by_title, ->(query) { where('title LIKE ?', "%#{query}%") }

end


# Changes:
# add column
# specify scope 
# update show


# serializer 


# draft
# archive
# published


# two attributes(is_deleted,status)


#Add
#  1.Can we add ability of user lo like a comment
#  2.  Get all the liked blogs for a user
#  3.  Get all the commented blogs for a user
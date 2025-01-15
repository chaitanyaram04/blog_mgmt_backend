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

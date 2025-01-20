class User < ApplicationRecord
    has_secure_password
    
    has_many :blogs, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    validates :user_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :role, inclusion: { in: %w[user admin], message: "%{value} is not a valid role" }, allow_nil: true
  end
  
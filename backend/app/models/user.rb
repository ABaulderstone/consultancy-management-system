class User < ApplicationRecord
  enum :role, { employee: 0, admin: 1 }
  has_secure_password
  has_one :profile
  has_many :contracts, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end

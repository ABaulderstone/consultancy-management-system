class User < ApplicationRecord
  enum :role, { employee: 0, admin: 1 }
  has_secure_password

  validates :email, presence: true, uniqueness: true
end

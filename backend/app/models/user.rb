class User < ApplicationRecord
  enum :role, { employee: 0, admin: 1 }
  has_secure_password
  has_one :profile, dependent: :destroy
  has_many :contracts, dependent: :destroy
  has_one :current_contract,
        -> { current },
        class_name: "Contract", dependent: :destroy
  has_one :active_assignment, -> {active}, class_name: "Assignment"
  has_one :current_job, through: :active_assignment, source: :job


  validates :email, presence: true, uniqueness: true
end

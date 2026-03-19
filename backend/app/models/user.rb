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

HAS_ACTIVE_CONTRACT = "EXISTS (SELECT 1 FROM contracts WHERE contracts.user_id = users.id AND contracts.end_date IS NULL)"
HAS_ANY_CONTRACT = "EXISTS (SELECT 1 FROM contracts WHERE contracts.user_id = users.id)"
HAS_ACTIVE_ASSIGNMENT = "EXISTS (SELECT 1 FROM assignments WHERE assignments.user_id = users.id AND assignments.end_date IS NULL)"

scope :active_employees, -> { where(HAS_ACTIVE_CONTRACT) }
scope :departed, -> { where.not(HAS_ACTIVE_CONTRACT).where(HAS_ANY_CONTRACT) }
scope :uncontracted, -> { where.not(HAS_ANY_CONTRACT) }
scope :assigned, -> { active_employees.where(HAS_ACTIVE_ASSIGNMENT) }
scope :on_bench, -> { active_employees.where.not(HAS_ACTIVE_ASSIGNMENT) }

scope :with_status_select, -> {
  select(
    'users.*',
    "#{HAS_ACTIVE_CONTRACT} AS has_active_contract",
    "#{HAS_ANY_CONTRACT} AS has_any_contract",
    "#{HAS_ACTIVE_ASSIGNMENT} AS has_active_assignment"
  )
}


  validates :email, presence: true, uniqueness: true
end

class Department < ApplicationRecord
  has_many :positions, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_insensitive: true }
  validates :billable, inclusion: { in: [true, false] }
end

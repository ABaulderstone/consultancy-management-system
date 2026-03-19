class Department < ApplicationRecord
  has_many :positions, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false}
  validates :billable, inclusion: { in: [true, false] }
end

class Position < ApplicationRecord
  belongs_to :department
  has_many :contracts, dependent: :restrict_with_error

  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  validates :title, presence: true
  validates :min_salary, :max_salary, numericality: { greater_than: 0 }, allow_nil: true
  validate :max_salary_greater_than_min

  def archived?
    archived_at.present?
  end

  def archive!
    update!(archived_at: Time.current)
  end

  private

  def max_salary_greater_than_min
    return unless min_salary && max_salary
    if max_salary <= min_salary
      errors.add(:max_salary, "must be greater than minimum salary")
    end
  end
end

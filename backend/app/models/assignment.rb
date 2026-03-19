
class Assignment < ApplicationRecord
  belongs_to :job
  belongs_to :user

  validates :start_date, presence: true
  validate :end_date_after_start_date
  validate :user_not_already_assigned, on: :create
  validate :job_not_already_assigned, on: :create

  scope :active, -> { where(end_date: nil) }

  private

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def user_not_already_assigned
    return unless user_id
    if Assignment.where(user_id: user_id, end_date: nil).exists?
      errors.add(:user, "is already assigned to a job")
    end
  end

  def job_not_already_assigned
    return unless job_id
    if Assignment.where(job_id: job_id, end_date: nil).exists?
      errors.add(:job, "already has an assigned consultant")
    end
  end
end
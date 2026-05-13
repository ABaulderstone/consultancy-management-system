class Job < ApplicationRecord
  belongs_to :client
  has_one :assignment
  has_one :active_assignment, -> { where(end_date: nil) }, class_name: "Assignment"


  validates :start_date, :day_rate, :title, presence: true
  validates :day_rate, numericality: { greater_than: 0 }
  validate :end_date_after_start_date

  # date-based
  scope :current,   -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.today, Date.today) }
  scope :upcoming,  -> { where("start_date > ?", Date.today) }
  scope :closed,    -> { where("end_date < ?", Date.today) }

  # assignment-based
  scope :assigned,    -> { where(id: Assignment.where(end_date: nil).select(:job_id)) }
  scope :unassigned,  -> { where.not(id: Assignment.where(end_date: nil).select(:job_id)) }

  # composite 
  scope :open,      -> { current.unassigned }
  scope :available, -> { upcoming.unassigned }

  scope :search, ->(term) {
  left_joins(:client, active_assignment: { user: :profile })
    .where(
      "jobs.title ILIKE :term OR clients.name ILIKE :term OR profiles.first_name ILIKE :term OR profiles.last_name ILIKE :term",
      term: "%#{term}%"
    )
    .distinct
}

  private

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end

end

class Job < ApplicationRecord
  belongs_to :client
  has_one :assignment

  validates :start_date, :day_rate, :title, presence: true
  validates :day_rate, numericality: { greater_than: 0 }
  validate :end_date_after_start_date

  scope :active, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.today, Date.today) }
  scope :completed, -> { where("end_date < ?", Date.today) }
  scope :upcoming, -> { where("start_date > ?", Date.today) }

  private

  def end_date_after_start_date
    return unless start_date && end_date
    if end_date <= start_date
      errors.add(:end_date, "must be after start date")
    end
  end

end

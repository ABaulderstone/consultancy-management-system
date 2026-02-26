class Contract < ApplicationRecord
  belongs_to :user
  validates :title, :salary, :start_date, presence: true
  validate :end_date_after_start_date

  scope :current, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.today, Date.today) }

  private

    def end_date_after_start_date
      return if end_date.nil? || start_date.nil?
      if end_date < start_date
        errors.add(:end_date, "must be after start date")
      end
    end
end

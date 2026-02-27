class Contract < ApplicationRecord
  belongs_to :user
  validates :title, :salary, :start_date, presence: true
  validate :end_date_after_start_date
  validate :only_one_active_contract


  scope :current, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.today, Date.today) }

  private

    def end_date_after_start_date
      return if end_date.nil? || start_date.nil?
      if end_date < start_date
        errors.add(:end_date, "must be after start date")
      end
    end

    def only_one_active_contract
      return unless end_date.nil?

      if user.contracts.where(end_date: nil).where.not(id: id).exists?
        errors.add(:base, "User already has an active contract")
      end
    end
end

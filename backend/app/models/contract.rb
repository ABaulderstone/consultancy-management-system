class Contract < ApplicationRecord
  belongs_to :user
  belongs_to :position

  enum :contract_type, { full_time: 0, part_time: 1, contractor: 2 }

  validates :rate, :start_date, :contract_type, presence: true
  validates :rate, numericality: { greater_than: 0 }
  validates :fte, numericality: { greater_than: 0, less_than_or_equal_to: 1 }, allow_nil: true
  validate :end_date_after_start_date
  validate :only_one_active_contract
  validate :fte_present_for_non_contractors
  validate :fte_absent_for_contractors
  validate :rate_within_salary_band


  scope :current, -> { where("start_date <= ? AND (end_date IS NULL OR end_date >= ?)", Date.today, Date.today) }

  def payable_rate
    contractor? ? rate : rate * (fte || 1.0)
  end

  def daily_cost
    contractor? ? rate : payable_rate / 260.0
  end

  private

    def end_date_after_start_date
      return unless start_date && end_date
      if end_date <= start_date
        errors.add(:end_date, "must be after start date")
      end
    end

    def only_one_active_contract
      return unless user_id && end_date.nil?
      existing = Contract.where(user_id: user_id, end_date: nil)
      existing = existing.where.not(id: id) if persisted?
      if existing.exists?
        errors.add(:base, "user already has an active contract")
      end
    end

  def fte_present_for_non_contractors
    return if contractor?
    if fte.nil?
      errors.add(:fte, "is required for non-contractor contracts")
    end
  end

  def fte_absent_for_contractors
    return unless contractor?
    if fte.present?
      errors.add(:fte, "must be blank for contractor contracts")
    end
  end


  def rate_within_salary_band
    return if contractor?
    return unless position&.min_salary && position&.max_salary
    return unless rate
    unless rate.between?(position.min_salary, position.max_salary)
      errors.add(:rate, "must be within the position salary band (#{position.min_salary} - #{position.max_salary})")
    end
  end
end

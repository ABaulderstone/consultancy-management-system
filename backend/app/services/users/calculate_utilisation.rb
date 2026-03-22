class Users::CalculateUtilisation < ApplicationService
 def initialize(user:, from: nil, to: nil)
    @user = user
    @from = from
    @to = to
 end

  def call
    return 0.0 if @user.assignments.empty?

    if @from && @to
      calculate_for_period(@from, @to)
    else
      calculate_lifetime
    end
  end

  private

  def calculate_lifetime
    first_contract_start = @user.contracts.minimum(:start_date)
    last_date = @user.current_contract ? Date.today : @user.contracts.maximum(:end_date)
    calculate(@user.assignments, first_contract_start, last_date)
  end

  def calculate_for_period(from, to)
    assignments = @user.assignments.select do |a|
      assignment_end = a.end_date || Date.today
      a.start_date <= to && assignment_end >= from
    end
    calculate(assignments, from, to)
  end

  def calculate(assignments, from, to)
    total_available = working_days_between(from, to)
    return 0.0 if total_available.zero?

    assigned = assignments.sum do |a|
      period_start = [a.start_date, from].max
      period_end = [a.end_date || Date.today, to].min
      next 0 if period_end < period_start
      working_days_between(period_start, period_end)
    end

    (assigned.to_f / total_available * 100).round(2)
  end

  def working_days_between(start_date, end_date)
    (start_date..end_date).count { |d| d.wday != 0 && d.wday != 6 }
  end
end
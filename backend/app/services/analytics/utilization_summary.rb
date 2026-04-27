class Analytics::UtilizationSummary < ApplicationService
  def initialize(period:)
    @period = period
  end

  def call
    case @period
    in { month: Date => month }
      daily_series(month.beginning_of_month, month.end_of_month)
    in { year: Date => year }
      monthly_series(year.beginning_of_year, year.end_of_year)
    end
  end

  private

  def daily_series(from, to)
    assignments = active_assignments_for(from, to)
    contracts = active_contracts_for(from, to)
    contracts_by_user = contracts.index_by(&:user_id)

    working_days(from, to).map do |date|
      assigned = assigned_fte_on(date, assignments, contracts_by_user)
      available = available_fte_on(date, contracts)

      build_entry(date, assigned, available)
    end
  end

  def monthly_series(from, to)
    daily_series(from, to)
      .group_by { |e| e[:date].beginning_of_month }
      .map do |month, entries|
        assigned = entries.sum { |e| e[:assigned] }
        available = entries.sum { |e| e[:available] }

        build_entry(month, assigned, available)
      end
  end

  def build_entry(date, assigned, available)
    utilization = available.zero? ? 0 :(assigned / available) * 100
    
    {
      date: date,
      assigned: assigned.round(2),
      available: available.round(2),
      utilization: utilization.round(2),
      projected: date > Date.today
    }
  end

  def working_days(from, to)
    (from..to).select { |d| d.wday != 0 && d.wday != 6 }
  end



  def active_assignments_for(from, to)
    Assignment
      .where("start_date <= ?", to)
      .where("end_date IS NULL OR end_date >= ?", from)
      .select(:user_id, :start_date, :end_date)
  end

  def active_contracts_for(from, to)
    Contract
      .joins(position: :department)
      .where(departments: { billable: true })
      .where("contracts.start_date <= ?", to)
      .where("contracts.end_date IS NULL OR contracts.end_date >= ?", from)
      .select(:user_id, :start_date, :end_date, :fte)
  end



  def available_fte_on(date, contracts)
    contracts.sum do |c|
      active_on?(date, c.start_date, c.end_date) ? c.fte.to_f : 0
    end
  end

  def assigned_fte_on(date, assignments, contracts_by_user)
    assignments.sum do |a|
      next 0 unless active_on?(date, a.start_date, a.end_date)

      contract = contracts_by_user[a.user_id]
      contract ? contract.fte.to_f : 0
    end
  end

  def active_on?(date, start_date, end_date)
    date >= start_date && (end_date.nil? || date <= end_date)
  end
end
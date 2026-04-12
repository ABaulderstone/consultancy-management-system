class Analytics::ProfitSummary < ApplicationService
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

    working_days(from, to).map do |date|
      build_entry(date, revenue_on(date, assignments), cost_on(date, contracts))
    end
  end

  def monthly_series(from, to)
    daily_series(from, to)
      .group_by { |entry| entry[:date].beginning_of_month }
      .map do |first_day, entries|
        build_entry(
          first_day,
          entries.sum { |e| e[:revenue] },
          entries.sum { |e| e[:cost] }
        )
      end
  end

  def build_entry(date, revenue, cost)
    {
      date: date,
      revenue: revenue.round(2),
      cost: cost.round(2),
      profit: (revenue - cost).round(2),
      projected: date > Date.today
    }
  end

  def working_days(from, to)
    (from..to).select { |d| d.wday != 0 && d.wday != 6 }
  end

  def active_assignments_for(from, to)
    Assignment
      .joins(:job)
      .where("assignments.start_date <= ?", to)
      .where("assignments.end_date IS NULL OR assignments.end_date >= ?", from)
      .select("assignments.start_date, assignments.end_date, jobs.day_rate")
  end

  def active_contracts_for(from, to)
    Contract
      .where("start_date <= ?", to)
      .where("end_date IS NULL OR end_date >= ?", from)
      .select(:start_date, :end_date, :rate, :fte, :contract_type)
  end

  def revenue_on(date, assignments)
    assignments.sum do |a|
      next 0 unless active_on?(date, a.start_date, a.end_date)
      a.day_rate.to_f
    end
  end

  def cost_on(date, contracts)
    contracts.sum do |c|
      next 0 unless active_on?(date, c.start_date, c.end_date)
      c.daily_cost.to_f
    end
  end

  def active_on?(date, start_date, end_date)
    date >= start_date && (end_date.nil? || date <= end_date)
  end
end
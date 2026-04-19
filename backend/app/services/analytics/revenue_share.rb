class Analytics::RevenueShare < ApplicationService
  def initialize(period:)
    @period = period
  end

  def call
    case @period
    in { month: Date => month }
      revenue_share(month.beginning_of_month, month.end_of_month)
    in { year: Date => year }
      revenue_share(year.beginning_of_year, year.end_of_year)
    end
  end

  private

  def revenue_share(from, to)
    rows = Assignment
      .joins(job: :client)
      .where("assignments.start_date <= ?", to)
      .where("assignments.end_date IS NULL OR assignments.end_date >= ?", from)
      .group("clients.name")
      .sum("jobs.day_rate")

    total = rows.values.sum.to_f

    shares = rows.map do |client_name, revenue|
      share = total.zero? ? 0 : (revenue.to_f / total) * 100

      {
        client_name: client_name,
        share: share
      }
    end.sort_by { |r| -r[:share] }

  
    diff = 100 - shares.sum { |s| s[:share] }
    shares.last[:share] += diff if shares.any?

    shares.each do |s|
      s[:share] = s[:share].round(2)
    end
    shares
  end
end
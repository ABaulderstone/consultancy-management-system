class Analytics::JobsFlowSummary < ApplicationService
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

  # --- Series ---

  def daily_series(from, to)
    started = started_counts(from, to)
    finished = finished_counts(from, to)
    current_active = active_before(from)

    working_days(from, to).map do |date|
      started_today = started[date] || 0
      finished_today = finished[date] || 0

      current_active += started_today
      current_active -= finished_today

      build_entry(date, started_today, finished_today, current_active)
    end
  end

  def monthly_series(from, to)
    daily_series(from, to)
      .group_by { |e| e[:date].beginning_of_month }
      .map do |month, entries|
        build_entry(
          month,
          entries.sum { |e| e[:started] },
          entries.sum { |e| e[:finished] },
          entries.last[:active] # snapshot
        )
      end
  end

  # --- Queries ---

  def started_counts(from, to)
    Job.where(start_date: from..to).group(:start_date).count
  end

  def finished_counts(from, to)
    Job.where(end_date: from..to).group(:end_date).count
  end

  def active_before(from)
    Job
      .where("start_date < ?", from)
      .where("end_date IS NULL OR end_date >= ?", from)
      .count
  end

  # --- Helpers ---

  def build_entry(date, started, finished, active)
    {
      date: date,
      started: started,
      finished: finished,
      active: active,
      projected: date > Date.today
    }
  end

  def working_days(from, to)
    (from..to).select { |d| d.wday != 0 && d.wday != 6 }
  end
end
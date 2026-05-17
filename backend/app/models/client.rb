class Client < ApplicationRecord
  has_many :jobs, dependent: :restrict_with_error

    scope :with_job_stats, -> {
    left_joins(:jobs)
      .select(
        "clients.*",
        "COUNT(jobs.id) AS jobs_count",
        "MIN(jobs.start_date) AS first_job_date",
        "COALESCE(ROUND(AVG(jobs.day_rate), 2), 0) AS average_day_rate",
        "COALESCE(SUM(jobs.day_rate * (COALESCE(jobs.end_date, CURRENT_DATE) - jobs.start_date) * 5.0 / 7.0), 0) AS total_revenue",
        "COUNT(jobs.id) FILTER (WHERE jobs.end_date < CURRENT_DATE) AS closed_count",
        "COUNT(jobs.id) FILTER (WHERE jobs.id IN (SELECT job_id FROM assignments WHERE end_date IS NULL)) AS assigned_count",
        "COUNT(jobs.id) FILTER (WHERE jobs.end_date IS NULL AND jobs.id NOT IN (SELECT job_id FROM assignments WHERE end_date IS NULL)) AS open_count"
      )
      .group("clients.id")
  }

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end

class Users::FindAvailableJobs < ApplicationService
  def initialize(user_id)
    @user_id = user_id
  end

def call
  Job
    .where("jobs.end_date IS NULL OR jobs.end_date >= ?", Date.today)
    .where.not(id: conflicting_job_ids)
    .where.not(id: Assignment.select(:job_id))
end

  private 

  def conflicting_job_ids
      Job
      .joins(
        "INNER JOIN assignments ON assignments.user_id = #{@user_id}"
      )
      .where(<<~SQL)
        NOT (
          (jobs.end_date IS NOT NULL AND jobs.end_date < assignments.start_date)
          OR
          (assignments.end_date IS NOT NULL AND jobs.start_date > assignments.end_date)
        )
      SQL
      .select(:id)
  end
end
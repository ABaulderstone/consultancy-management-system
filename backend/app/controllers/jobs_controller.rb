class JobsController < ApplicationController
  before_action :only_admin!

  def index
    jobs = Job
      .includes(:client, active_assignment: { user: :profile })
      .order(start_date: :desc)

    jobs = case params[:status]
      when "open"      then jobs.merge(Job.open)
      when "assigned"  then jobs.merge(Job.assigned)
      when "available" then jobs.merge(Job.available)
      when "closed"    then jobs.merge(Job.closed)
      else jobs
    end

    jobs = jobs.search(params[:search]) if params[:search].present?
    paginated_response(jobs, JobBlueprint)
  end

end
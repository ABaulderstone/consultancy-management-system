
class EnrichedClientBlueprint < Blueprinter::Base
  identifier :id
  field :name

  field :jobs_count do |client, _|
    client.jobs_count.to_i
  end

  field :first_job_date do |client, _|
    client.first_job_date
  end

  field :average_day_rate do |client, _|
    client.average_day_rate.to_f
  end

  field :total_revenue do |client, _|
    client.total_revenue.to_f.round(2)
  end

  field :job_breakdown do |client, _|
    {
      assigned: client.assigned_count.to_i,
      open: client.open_count.to_i,
      closed: client.closed_count.to_i
    }
  end
end
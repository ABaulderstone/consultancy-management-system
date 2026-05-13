class JobBlueprint < Blueprinter::Base
  identifier :id
  fields :title, :start_date, :end_date

  field :day_rate do |job, _|
    job.day_rate.to_f
  end

  field :client do |job, _|
    { name: job.client.name }
  end

  field :assignment do |job, _|
    next unless job.active_assignment

    {
      id: job.active_assignment.id,
      start_date: job.active_assignment.start_date,
      user: {
        name: job.active_assignment.user.profile&.then { "#{_1.first_name} #{_1.last_name}" }
      }
    }
  end
end
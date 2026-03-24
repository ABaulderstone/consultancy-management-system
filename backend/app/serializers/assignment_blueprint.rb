# app/blueprints/assignment_blueprint.rb
class AssignmentBlueprint < Blueprinter::Base
  identifier :id
  fields :start_date, :end_date

  field :job do |assignment, _|
    {
      title: assignment.job&.title,
      client: assignment.job&.client&.name,
      day_rate: assignment.job&.day_rate.to_f
    }
  end
end

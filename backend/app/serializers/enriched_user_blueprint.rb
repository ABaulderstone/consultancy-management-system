class EnrichedUserBlueprint < Blueprinter::Base
  identifier :id
  fields :email, :role

  field :first_name do |user, _|
    user.profile&.first_name
  end

  field :last_name do |user, _|
    user.profile&.last_name
  end

  field :title do |user, _|
    user.profile&.title
  end

  field :gender do |user, _|
    user.profile&.gender
  end

  field :date_of_birth do |user, _|
    user.profile&.date_of_birth
  end

  field :employment_status do |user, _|
    if user[:has_active_contract]
      'active'
    elsif user[:has_any_contract]
      'departed'
    else
      'uncontracted'
    end
  end

  field :assignment_status do |user, _|
    if user[:has_active_contract] && user.current_contract&.position&.department&.billable
      user[:has_active_assignment] ? 'assigned' : 'bench'
    end
  end
end 

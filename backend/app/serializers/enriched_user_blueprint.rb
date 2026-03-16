class EnrichedUserBlueprint < Blueprinter::Base
  identifier :id
  fields :email, :role

  field :first_name do |user, _options|
    user.profile&.first_name
  end

  field :last_name do |user, _options|
    user.profile&.last_name
  end

  field :title do |user, _options|
    user.profile&.title
  end

  field :gender do |user, _options|
    user.profile&.gender
  end

  field :date_of_birth do |user, _options|
    user.profile&.date_of_birth
  end

  field :age do |user, _options|
    user.profile&.age
  end

end

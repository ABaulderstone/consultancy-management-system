class Users::CreateUser < ApplicationService
  include Users::EmailGeneratable
  def initialize(params:)
    @params = params
  end
  def call
    first_name, last_name = @params.values_at(:first_name, :last_name)

    ActiveRecord::Base.transaction do
      password = SecureRandom.alphanumeric(12)
      next_id = ActiveRecord::Base.connection.execute("SELECT nextval('users_id_seq')").first["nextval"]
      user = User.create!(id: next_id, email: "placeholder_#{next_id}@example.com", password: password, password_confirmation: password)
      Profile.create!(user: user, **@params)
      # not ideal but better error clarity worth the single update within transaction for probably an infrequent operation
      user.update!(email: generate_email(next_id, first_name, last_name))
      { user: user, password: password }
    end
  end
end

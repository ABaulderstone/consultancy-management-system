class Users::UpdateUser < ApplicationService
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      if name_changed?
        @user.update!(email: generate_email(@user.id, @params[:first_name], @params[:last_name]))
      end

      @user.profile.update!(profile_params)

      @user
    end
  end

  private

    def name_changed?
      @params[:first_name] != @user.profile.first_name ||
        @params[:last_name] != @user.profile.last_name
    end

    def profile_params
      @params.slice(:first_name, :last_name, :date_of_birth, :gender, :title)
    end

    # TODO: DRY duplicate email gen.
    def generate_email(id, first_name, last_name)
      return if first_name.nil? || last_name.nil?
      padded_id = id.to_s.rjust(4, "0")
      "#{first_name.downcase}.#{last_name.downcase}.#{padded_id}@example.com"
    end
end

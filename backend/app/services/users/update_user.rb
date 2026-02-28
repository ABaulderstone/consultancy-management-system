class Users::UpdateUser < ApplicationService
  include Users::EmailGeneratable
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      email_needs_update = name_changed?

      @user.profile.update!(profile_params)

      if email_needs_update
        @user.update!(email: generate_email(@user.id, @params[:first_name], @params[:last_name]))
      end

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
end

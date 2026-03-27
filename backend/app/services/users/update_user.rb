class Users::UpdateUser < ApplicationService
  include Users::EmailGeneratable
  include Users::Sluggable
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      if name_changed?
        # doubling logic to force invalid params error if needed
        @user.profile.update!(profile_params)
        @user.update!(email: generate_email(@user.id, @params[:first_name], @params[:last_name]))
        update_slug!(@user.profile)
      else
        @user.profile.update!(profile_params)
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

require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_one(:profile) }
    it { should have_many(:contracts).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should have_secure_password }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(employee: 0, admin: 1) }
  end
end

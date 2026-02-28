require "rails_helper"

RSpec.describe Profile, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe "enums" do
    it { should define_enum_for(:gender).with_values(male: 0, female: 1, other: 2, prefer_not_to_say: 3) }
  end

  describe "#age" do
    let(:profile) { build(:profile, date_of_birth: 30.years.ago.to_date) }

    it "returns the correct age" do
      expect(profile.age).to eq(30)
    end

    it "returns nil when date_of_birth is not set" do
      profile.date_of_birth = nil
      expect(profile.age).to be_nil
    end

    it "calculates correctly before birthday this year" do
      profile.date_of_birth = Date.new(Date.today.year - 30, 12, 31)

      expect(profile.age).to eq(29)
    end
  end

  describe "date_of_birth validation" do
    it "is valid with a proper date" do
      profile = build(:profile, date_of_birth: "1990-01-01")
      expect(profile).to be_valid
    end

    it "is valid without a date_of_birth" do
      profile = build(:profile, date_of_birth: nil)
      expect(profile).to be_valid
    end
  end
end

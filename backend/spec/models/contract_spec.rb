require "rails_helper"

RSpec.describe Contract, type: :model do
  subject { build(:contract) }
  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:salary) }
    it { should validate_presence_of(:start_date) }
  end

  describe "end_date_after_start_date" do
    it "is invalid when end_date is before start_date" do
      contract = build(:contract, start_date: Date.today, end_date: Date.today - 1.day)
      expect(contract).not_to be_valid
      expect(contract.errors[:end_date]).to include("must be after start date")
    end

    it "is valid when end_date is after start_date" do
      contract = build(:contract, start_date: Date.today, end_date: Date.today + 1.day)
      expect(contract).to be_valid
    end

    it "is valid when end_date is nil" do
      contract = build(:contract, start_date: Date.today, end_date: nil)
      expect(contract).to be_valid
    end
  end

  describe "only_one_active_contract" do
    let(:user) { create(:user) }

    it "is invalid when user already has an active contract" do
      create(:contract, user: user, end_date: nil)
      contract = build(:contract, user: user, end_date: nil)
      expect(contract).not_to be_valid
      expect(contract.errors[:base]).to include("User already has an active contract")
    end

    it "is valid when existing contracts all have end dates" do
      create(:contract, user: user, end_date: Date.today + 1.year)
      contract = build(:contract, user: user, end_date: nil)
      expect(contract).to be_valid
    end
  end

  describe ".current scope" do
    let(:user) { create(:user) }

    it "returns contracts active today" do
      contract = create(:contract, user: user, start_date: Date.today - 1.month, end_date: nil)
      expect(Contract.current).to include(contract)
    end

    it "excludes contracts that have ended" do
      contract = create(:contract, user: user, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
      expect(Contract.current).not_to include(contract)
    end

    it "excludes contracts that haven't started yet" do
      contract = create(:contract, user: user, start_date: Date.today + 1.month, end_date: nil)
      expect(Contract.current).not_to include(contract)
    end
  end
end

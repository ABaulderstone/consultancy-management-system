require "rails_helper"

RSpec.describe Contract, type: :model do
  subject { build(:contract) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:position) }
  end

  describe "validations" do
    it { should validate_presence_of(:rate) }
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:contract_type) }
    it { should validate_numericality_of(:rate).is_greater_than(0) }
    it { should validate_numericality_of(:fte).is_greater_than(0).is_less_than_or_equal_to(1).allow_nil }
  end

  describe "enums" do
    it { should define_enum_for(:contract_type).with_values(full_time: 0, part_time: 1, contractor: 2) }
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
      expect(contract.errors[:base]).to include("user already has an active contract")
    end

    it "is valid when existing contracts all have end dates" do
      create(:contract, user: user, end_date: Date.today + 1.year)
      contract = build(:contract, user: user, end_date: nil)
      expect(contract).to be_valid
    end

    it "does not fail when updating an existing active contract" do
      contract = create(:contract, user: user, end_date: nil)
      contract.rate = 60_000
      expect(contract).to be_valid
    end
  end

  describe "fte_present_for_non_contractors" do
    it "is invalid when fte is nil for full time contract" do
      contract = build(:contract, contract_type: :full_time, fte: nil)
      expect(contract).not_to be_valid
      expect(contract.errors[:fte]).to include("is required for non-contractor contracts")
    end

    it "is invalid when fte is nil for part time contract" do
      contract = build(:contract, contract_type: :part_time, fte: nil)
      expect(contract).not_to be_valid
      expect(contract.errors[:fte]).to include("is required for non-contractor contracts")
    end

    it "is valid when fte is nil for contractor" do
      contract = build(:contract, contract_type: :contractor, fte: nil)
      expect(contract).to be_valid
    end
  end

  describe "rate_within_salary_band" do
    let(:position) { create(:position, min_salary: 55_000, max_salary: 70_000) }

    it "is invalid when rate is below the salary band" do
      contract = build(:contract, position: position, contract_type: :full_time, rate: 50_000)
      expect(contract).not_to be_valid
      expect(contract.errors[:rate]).to include(/must be within the position salary band/)
    end

    it "is invalid when rate is above the salary band" do
      contract = build(:contract, position: position, contract_type: :full_time, rate: 80_000)
      expect(contract).not_to be_valid
      expect(contract.errors[:rate]).to include(/must be within the position salary band/)
    end

    it "is valid when rate is within the salary band" do
      contract = build(:contract, position: position, contract_type: :full_time, rate: 62_000)
      expect(contract).to be_valid
    end

    it "does not validate band for contractors" do
      contract = build(:contract, position: position, contract_type: :contractor, fte: nil, rate: 800)
      expect(contract).to be_valid
    end
  end

  describe "virtual attributes" do
    let(:position) { create(:position, min_salary: 55_000, max_salary: 70_000) }

    it "calculates payable_rate for full time" do
      contract = build(:contract, contract_type: :full_time, rate: 60_000, fte: 1.0)
      expect(contract.payable_rate).to eq(60_000)
    end

    it "calculates payable_rate for part time" do
      contract = build(:contract, contract_type: :part_time, rate: 60_000, fte: 0.6)
      expect(contract.payable_rate).to eq(36_000)
    end

    it "calculates payable_rate for contractor" do
      contract = build(:contract, contract_type: :contractor, rate: 600, fte: nil)
      expect(contract.payable_rate).to eq(600)
    end

    it "calculates daily_cost for full time" do
      contract = build(:contract, contract_type: :full_time, rate: 65_000, fte: 1.0)
      expect(contract.daily_cost).to be_within(0.01).of(65_000 / 260.0)
    end

    it "calculates daily_cost for contractor" do
      contract = build(:contract, contract_type: :contractor, rate: 600, fte: nil)
      expect(contract.daily_cost).to eq(600)
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
require 'rails_helper'

RSpec.describe Position, type: :model do
  subject { build(:position) }

  describe "associations" do
    it { should belong_to(:department) }
    it { should have_many(:contracts).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_numericality_of(:min_salary).is_greater_than(0).allow_nil }
    it { should validate_numericality_of(:max_salary).is_greater_than(0).allow_nil }
  end

  describe "max_salary_greater_than_min" do
    it "is invalid when max_salary is less than min_salary" do
      position = build(:position, min_salary: 70_000, max_salary: 60_000)
      expect(position).not_to be_valid
      expect(position.errors[:max_salary]).to include("must be greater than minimum salary")
    end

    it "is invalid when max_salary equals min_salary" do
      position = build(:position, min_salary: 60_000, max_salary: 60_000)
      expect(position).not_to be_valid
      expect(position.errors[:max_salary]).to include("must be greater than minimum salary")
    end

    it "is valid when max_salary is greater than min_salary" do
      position = build(:position, min_salary: 55_000, max_salary: 70_000)
      expect(position).to be_valid
    end

    it "is valid when both are nil" do
      position = build(:position, min_salary: nil, max_salary: nil)
      expect(position).to be_valid
    end
  end

  describe "scopes" do
    it "active returns positions where archived_at is nil" do
      active = create(:position)
      archived = create(:position, archived_at: 1.week.ago)
      expect(Position.active).to include(active)
      expect(Position.active).not_to include(archived)
    end

    it "archived returns positions where archived_at is present" do
      active = create(:position)
      archived = create(:position, archived_at: 1.week.ago)
      expect(Position.archived).to include(archived)
      expect(Position.archived).not_to include(active)
    end
  end

  describe "#archived?" do
    it "returns true when archived_at is present" do
      position = build(:position, archived_at: 1.week.ago)
      expect(position.archived?).to be true
    end

    it "returns false when archived_at is nil" do
      position = build(:position, archived_at: nil)
      expect(position.archived?).to be false
    end
  end

  describe "#archive!" do
    it "sets archived_at to current time" do
      position = create(:position)
      position.archive!
      expect(position.archived_at).to be_within(1.second).of(Time.current)
    end
  end
end
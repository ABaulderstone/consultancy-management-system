require 'rails_helper'

RSpec.describe Job, type: :model do
  subject { build(:job) }

  describe "associations" do
    it { should belong_to(:client) }
    it { should have_one(:assignment) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:day_rate) }
    it { should validate_numericality_of(:day_rate).is_greater_than(0) }
  end

  describe "end_date_after_start_date" do
    it "is invalid when end_date is before start_date" do
      job = build(:job, start_date: Date.today, end_date: Date.today - 1.day)
      expect(job).not_to be_valid
      expect(job.errors[:end_date]).to include("must be after start date")
    end

    it "is valid when end_date is after start_date" do
      job = build(:job, start_date: Date.today, end_date: Date.today + 1.day)
      expect(job).to be_valid
    end

    it "is valid when end_date is nil" do
      job = build(:job, start_date: Date.today, end_date: nil)
      expect(job).to be_valid
    end
  end

  describe "scopes" do
    it "active returns jobs with no end date" do
      active = create(:job, end_date: nil)
      completed = create(:job, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
      expect(Job.active).to include(active)
      expect(Job.active).not_to include(completed)
    end

    it "completed returns jobs with an end date" do
      active = create(:job, start_date: Date.today - 2.months, end_date: nil)
      completed = create(:job, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
      expect(Job.completed).to include(completed)
      expect(Job.completed).not_to include(active)
    end
  end
end
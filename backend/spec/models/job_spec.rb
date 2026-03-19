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
      it "active returns jobs that have started and not ended" do
        active = create(:job, start_date: Date.today - 1.month, end_date: nil)
        active_with_future_end = create(:job, start_date: Date.today - 1.month, end_date: Date.today + 1.month)
        completed = create(:job, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
        upcoming = create(:job, start_date: Date.today + 1.month, end_date: nil)
        expect(Job.active).to include(active, active_with_future_end)
        expect(Job.active).not_to include(completed, upcoming)
      end

      it "completed returns jobs whose end date has passed" do
        completed = create(:job, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
        active = create(:job, start_date: Date.today - 1.month, end_date: nil)
        expect(Job.completed).to include(completed)
        expect(Job.completed).not_to include(active)
      end

      it "upcoming returns jobs that have not started yet" do
        upcoming = create(:job, start_date: Date.today + 1.month, end_date: nil)
        active = create(:job, start_date: Date.today - 1.month, end_date: nil)
        completed = create(:job, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
        expect(Job.upcoming).to include(upcoming)
        expect(Job.upcoming).not_to include(active, completed)
      end

  end 
end
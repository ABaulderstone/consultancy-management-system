require 'rails_helper'

RSpec.describe Job, type: :model do
  subject { build(:job) }

  describe "associations" do
    it { should belong_to(:client) }
    it { should have_one(:assignment) }
    it { should have_one(:active_assignment) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:day_rate) }
    it { should validate_presence_of(:title) }
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
    describe ".current" do
      it "includes jobs that have started with no end date" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.current).to include(job)
      end

      it "includes jobs that have started with a future end date" do
        job = create(:job, start_date: 1.month.ago, end_date: 1.month.from_now)
        expect(Job.current).to include(job)
      end

      it "excludes upcoming jobs" do
        job = create(:job, start_date: 1.month.from_now, end_date: nil)
        expect(Job.current).not_to include(job)
      end

      it "excludes closed jobs" do
        job = create(:job, start_date: 2.months.ago, end_date: 1.month.ago)
        expect(Job.current).not_to include(job)
      end
    end

    describe ".upcoming" do
      it "includes jobs that have not started yet" do
        job = create(:job, start_date: 1.month.from_now, end_date: nil)
        expect(Job.upcoming).to include(job)
      end

      it "excludes jobs that have already started" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.upcoming).not_to include(job)
      end

      it "excludes closed jobs" do
        job = create(:job, start_date: 2.months.ago, end_date: 1.month.ago)
        expect(Job.upcoming).not_to include(job)
      end
    end

    describe ".closed" do
      it "includes jobs whose end date has passed" do
        job = create(:job, start_date: 2.months.ago, end_date: 1.month.ago)
        expect(Job.closed).to include(job)
      end

      it "excludes jobs with no end date" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.closed).not_to include(job)
      end

      it "excludes jobs with a future end date" do
        job = create(:job, start_date: 1.month.ago, end_date: 1.month.from_now)
        expect(Job.closed).not_to include(job)
      end
    end

    describe ".assigned" do
      it "includes jobs with an active assignment" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        create(:assignment, job: job, end_date: nil)
        expect(Job.assigned).to include(job)
      end

      it "excludes jobs with only a closed assignment" do
        job = create(:job, start_date: 2.months.ago, end_date: nil)
        create(:assignment, job: job, end_date: 1.month.ago)
        expect(Job.assigned).not_to include(job)
      end

      it "excludes jobs with no assignment" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.assigned).not_to include(job)
      end
    end

    describe ".unassigned" do
      it "includes jobs with no assignment" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.unassigned).to include(job)
      end

      it "includes jobs with only a closed assignment" do
        job = create(:job, start_date: 2.months.ago, end_date: nil)
        create(:assignment, job: job, end_date: 1.month.ago)
        expect(Job.unassigned).to include(job)
      end

      it "excludes jobs with an active assignment" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        create(:assignment, job: job, end_date: nil)
        expect(Job.unassigned).not_to include(job)
      end
    end

    describe ".open" do
      it "includes current unassigned jobs" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.open).to include(job)
      end

      it "excludes current assigned jobs" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        create(:assignment, job: job, end_date: nil)
        expect(Job.open).not_to include(job)
      end

      it "excludes closed jobs" do
        job = create(:job, start_date: 2.months.ago, end_date: 1.month.ago)
        expect(Job.open).not_to include(job)
      end

      it "excludes upcoming jobs" do
        job = create(:job, start_date: 1.month.from_now, end_date: nil)
        expect(Job.open).not_to include(job)
      end
    end

    describe ".available" do
      it "includes upcoming unassigned jobs" do
        job = create(:job, start_date: 1.month.from_now, end_date: nil)
        expect(Job.available).to include(job)
      end

      it "excludes upcoming assigned jobs" do
        job = create(:job, start_date: 1.month.from_now, end_date: nil)
        create(:assignment, job: job, end_date: nil)
        expect(Job.available).not_to include(job)
      end

      it "excludes current jobs" do
        job = create(:job, start_date: 1.month.ago, end_date: nil)
        expect(Job.available).not_to include(job)
      end
    end
  end
end
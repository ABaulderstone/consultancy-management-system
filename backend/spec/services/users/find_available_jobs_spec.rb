require "rails_helper"

RSpec.describe Users::FindAvailableJobs, type: :service do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe ".call" do
    subject(:result) { described_class.new(user.id).call }

    context "when the user has no assignments" do
      it "returns all open jobs" do
        job_one = create(:job, start_date: 1.week.ago, end_date: nil)
        job_two = create(:job, start_date: 1.week.ago, end_date: 2.weeks.from_now)
        expect(result).to include(job_one, job_two)
      end

      it "excludes jobs with a past end date" do
        create(:job, start_date: 4.weeks.ago, end_date: 1.week.ago)
        expect(result).to be_empty
      end
    end

    context "when a job is already assigned to another user" do
      it "excludes jobs with an active assignment" do
        job = create(:job, start_date: 1.week.ago, end_date: nil)
        create(:assignment, job: job, user: other_user, start_date: 1.week.ago, end_date: nil)
        expect(result).not_to include(job)
      end

      it "excludes jobs with a historical assignment" do
        job = create(:job, start_date: 4.weeks.ago, end_date: nil)
        create(:assignment, job: job, user: other_user, start_date: 4.weeks.ago, end_date: 2.weeks.ago)
        expect(result).not_to include(job)
      end
    end

    context "when the user has an active assignment" do
      before do
        assigned_job = create(:job, start_date: 2.months.ago, end_date: nil)
        create(:assignment, user: user, job: assigned_job, start_date: 2.months.ago, end_date: nil)
      end

      it "excludes jobs that overlap with the active assignment" do
        job = create(:job, start_date: 1.week.ago, end_date: nil)
        expect(result).not_to include(job)
      end

      it "excludes jobs that started before the active assignment with no end date" do
        job = create(:job, start_date: 3.months.ago, end_date: nil)
        expect(result).not_to include(job)
      end
    end

    context "when the user has a closed assignment" do
      before do
        assigned_job = create(:job, start_date: 4.months.ago, end_date: 2.months.ago)
        create(:assignment, user: user, job: assigned_job, start_date: 4.months.ago, end_date: 2.months.ago)
      end

      it "excludes jobs that overlap with the closed assignment" do
        job = create(:job, start_date: 3.months.ago, end_date: nil)
        expect(result).not_to include(job)
      end

      it "includes jobs that start after the closed assignment ends" do
        job = create(:job, start_date: 1.week.ago, end_date: nil)
        expect(result).to include(job)
      end

      it "includes jobs that end before the closed assignment starts" do
        job = create(:job, start_date: 6.months.ago, end_date: 5.months.ago)
        expect(result).not_to include(job) # also caught by end_date filter
      end
    end
  end
end
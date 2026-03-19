require 'rails_helper'

RSpec.describe Assignment, type: :model do
  subject { build(:assignment) }

  describe "associations" do
    it { should belong_to(:job) }
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:start_date) }
  end

  describe "end_date_after_start_date" do
    it "is invalid when end_date is before start_date" do
      assignment = build(:assignment, start_date: Date.today, end_date: Date.today - 1.day)
      expect(assignment).not_to be_valid
      expect(assignment.errors[:end_date]).to include("must be after start date")
    end

    it "is valid when end_date is after start_date" do
      assignment = build(:assignment, start_date: Date.today, end_date: Date.today + 1.day)
      expect(assignment).to be_valid
    end

    it "is valid when end_date is nil" do
      assignment = build(:assignment, start_date: Date.today, end_date: nil)
      expect(assignment).to be_valid
    end
  end

  describe "user_not_already_assigned" do
    let(:user) { create(:user) }

    it "is invalid when user already has an active assignment" do
      create(:assignment, user: user, end_date: nil)
      assignment = build(:assignment, user: user, end_date: nil)
      expect(assignment).not_to be_valid
      expect(assignment.errors[:user]).to include("is already assigned to a job")
    end

      it "is valid when user has no active assignment" do
        create(:assignment, user: user, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
        assignment = build(:assignment, user: user, end_date: nil)
        expect(assignment).to be_valid
      end
  end

  describe "job_not_already_assigned" do
    let(:job) { create(:job) }

    it "is invalid when job already has an active assignment" do
      create(:assignment, job: job, end_date: nil)
      assignment = build(:assignment, job: job, end_date: nil)
      expect(assignment).not_to be_valid
      expect(assignment.errors[:job]).to include("already has an assigned consultant")
    end

    it "is valid when job has no active assignment" do
      create(:assignment, job: job, start_date: Date.today - 2.months, end_date: Date.today - 1.month)
      assignment = build(:assignment, job: job, end_date: nil)
      expect(assignment).to be_valid
    end
  end

  describe "scopes" do
    it "active returns assignments with no end date" do
      active = create(:assignment, end_date: nil)
      completed = create(:assignment, end_date: Date.today - 1.month)
      expect(Assignment.active).to include(active)
      expect(Assignment.active).not_to include(completed)
    end
  end
end

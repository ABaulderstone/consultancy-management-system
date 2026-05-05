require "rails_helper"

RSpec.describe Analytics::UtilizationSummary, type: :service do
  let(:today) { Date.new(2024, 3, 15) }

  before { travel_to(today) }
  after  { travel_back }

  let(:march) { Date.new(2024, 3) }
  let(:year)  { Date.new(2024, 1) }

  def create_contract(user:, fte:, billable: true)
    department = create(:department, billable: billable)
    position = create(:position, department: department)

    create(:contract,
      user: user,
      position: position,
      fte: fte,
      start_date: Date.new(2023, 1, 1),
      end_date: nil
    )
  end

  def create_assignment(user:)
    job = create(:job, start_date: Date.new(2023, 1, 1), end_date: nil)
    create(:assignment,
      user: user,
      job: job,
      start_date: Date.new(2023, 1, 1),
      end_date: nil
    )
  end

  describe ".call" do
    context "monthly" do
      let(:period) { { month: march } }

      it "returns one entry per working day" do
        result = described_class.call(period: period)

        expected = (Date.new(2024, 3, 1)..Date.new(2024, 3, 31))
          .count { |d| d.wday != 0 && d.wday != 6 }

        expect(result.length).to eq(expected)
      end

      it "returns correct keys" do
        result = described_class.call(period: period)
        expect(result.first.keys).to match_array([:date, :assigned, :available, :utilization, :projected])
      end

      context "with one full-time assigned user" do
        before do
          user = create(:user)
          create_contract(user: user, fte: 1.0)
          create_assignment(user: user)
        end

        it "has 100% utilization" do
          result = described_class.call(period: period)
          entry = result.first

          expect(entry[:assigned]).to eq(1.0)
          expect(entry[:available]).to eq(1.0)
          expect(entry[:utilization]).to eq(100.0)
        end
      end

      context "with partial FTE" do
        before do
          user = create(:user)
          create_contract(user: user, fte: 0.5)
          create_assignment(user: user)
        end

        it "uses FTE instead of count" do
          result = described_class.call(period: period)
          entry = result.first

          expect(entry[:assigned]).to eq(0.5)
          expect(entry[:available]).to eq(0.5)
        end
      end

      context "with unassigned capacity" do
        before do
          user = create(:user)
          create_contract(user: user, fte: 1.0)
        end

        it "results in 0% utilization" do
          result = described_class.call(period: period)
          entry = result.first

          expect(entry[:assigned]).to eq(0.0)
          expect(entry[:available]).to eq(1.0)
          expect(entry[:utilization]).to eq(0.0)
        end
      end

      context "with non-billable contract" do
        before do
          user = create(:user)
          create_contract(user: user, fte: 1.0, billable: false)
          create_assignment(user: user)
        end

        it "excludes it from capacity" do
          result = described_class.call(period: period)
          entry = result.first

          expect(entry[:available]).to eq(0.0)
          expect(entry[:assigned]).to eq(0.0)
        end
      end

      context "projected flag" do
        it "marks future days as projected" do
          result = described_class.call(period: period)

          future = result.find { |e| e[:date] == Date.new(2024, 3, 20) }
          expect(future[:projected]).to be true
        end
      end

      context "zero capacity" do
        it "does not divide by zero" do
          result = described_class.call(period: period)
          expect(result.first[:utilization]).to eq(0)
        end
      end
    end

    context "yearly" do
      let(:period) { { year: year } }

      it "returns 12 entries" do
        result = described_class.call(period: period)
        expect(result.length).to eq(12)
      end

      it "aggregates assigned and available across the month" do
        user = create(:user)
        create_contract(user: user, fte: 1.0)
        create_assignment(user: user)

        result = described_class.call(period: period)

        january = result.find { |e| e[:date].month == 1 }
        expect(january[:assigned]).to be > 0
        expect(january[:available]).to be > 0
      end
    end
  end
end
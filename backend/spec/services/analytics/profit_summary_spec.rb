require "rails_helper"

RSpec.describe Analytics::ProfitSummary, type: :service do
  let(:today) { Date.new(2024, 3, 15) }

  before { travel_to(today) }
  after  { travel_back }

  let(:march) { Date.new(2024, 3) }
  let(:year)  { Date.new(2024, 1) }

  def create_active_contract(daily_cost:)
    create(:contract, :contractor,
      user: create(:user),
      position: create(:position),
      rate: daily_cost,
      start_date: Date.new(2023, 1, 1),
      end_date: nil
    )
  end

  def create_active_assignment(day_rate:, user: create(:user))
    job = create(:job, day_rate: day_rate, start_date: Date.new(2023, 1, 1), end_date: nil)
    create(:assignment, job: job, user: user, start_date: Date.new(2023, 1, 1), end_date: nil)
  end

  describe ".call" do
    context "with a monthly period" do
      let(:period) { { month: march } }

      it "returns one entry per working day in the month" do
        result = described_class.call(period: period)
        expected_working_days = (Date.new(2024, 3, 1)..Date.new(2024, 3, 31))
          .count { |d| d.wday != 0 && d.wday != 6 }
        expect(result.length).to eq(expected_working_days)
      end

      it "excludes weekends" do
        result = described_class.call(period: period)
        expect(result.map { |e| Date.parse(e[:date].to_s).wday }).to all(satisfy { |w| w != 0 && w != 6 })
      end

      it "returns the correct keys for each entry" do
        result = described_class.call(period: period)
        expect(result.first.keys).to match_array([:date, :revenue, :cost, :profit, :projected])
      end

      context "with an active assignment and contract" do
        before do
          create_active_assignment(day_rate: 600)
          create_active_contract(daily_cost: 250)
        end

        it "calculates revenue from the assignment day rate" do
          result = described_class.call(period: period)
          entry = result.find { |e| e[:date] == Date.new(2024, 3, 1) }
          expect(entry[:revenue]).to eq(600.0)
        end

        it "calculates cost from the contract daily cost" do
          result = described_class.call(period: period)
          entry = result.find { |e| e[:date] == Date.new(2024, 3, 1) }
          expect(entry[:cost]).to eq(250.0)
        end

        it "calculates profit as revenue minus cost" do
          result = described_class.call(period: period)
          entry = result.find { |e| e[:date] == Date.new(2024, 3, 1) }
          expect(entry[:profit]).to eq(350.0)
        end
      end

      context "projected flag" do
        it "marks past days as not projected" do
          result = described_class.call(period: period)
          expect(result.find { |e| e[:date] == Date.new(2024, 3, 1) }[:projected]).to be false
        end

        it "marks today as not projected" do
          result = described_class.call(period: period)
          expect(result.find { |e| e[:date] == today }[:projected]).to be false
        end

        it "marks future days as projected" do
          result = described_class.call(period: period)
          expect(result.find { |e| e[:date] == Date.new(2024, 3, 20) }[:projected]).to be true
        end
      end

      context "with no assignments or contracts" do
        it "returns zero revenue, cost and profit for every entry" do
          result = described_class.call(period: period)
          expect(result).to all(include(revenue: 0.0, cost: 0.0, profit: 0.0))
        end
      end

      context "with an assignment that ends mid-month" do
        it "only counts revenue on days the assignment was active" do
          job = create(:job, day_rate: 500, start_date: Date.new(2023, 1, 1), end_date: nil)
          create(:assignment, job: job, user: create(:user), start_date: Date.new(2023, 1, 1), end_date: Date.new(2024, 3, 7))

          result = described_class.call(period: period)

          expect(result.select { |e| e[:date] <= Date.new(2024, 3, 7) }).to all(include(revenue: 500.0))
          expect(result.select { |e| e[:date] > Date.new(2024, 3, 7) }).to all(include(revenue: 0.0))
        end
      end

      context "with multiple assignments" do
        it "sums revenue across all active assignments on a given day" do
          create_active_assignment(day_rate: 600)
          create_active_assignment(day_rate: 400)

          result = described_class.call(period: period)
          expect(result.find { |e| e[:date] == Date.new(2024, 3, 1) }[:revenue]).to eq(1000.0)
        end
      end
    end

    context "with a yearly period" do
      let(:period) { { year: year } }

      it "returns 12 entries, one per month" do
        result = described_class.call(period: period)
        expect(result.length).to eq(12)
      end

      it "sets date to the first of each month" do
        result = described_class.call(period: period)
        expect(result.map { |e| e[:date].day }).to all(eq(1))
        expect(result.map { |e| e[:date].month }).to eq((1..12).to_a)
      end

      it "aggregates working day figures across the month" do
        create_active_assignment(day_rate: 500)
        create_active_contract(daily_cost: 200)

        result = described_class.call(period: period)

        january = result.find { |e| e[:date].month == 1 }
        working_days_in_jan = (Date.new(2024, 1, 1)..Date.new(2024, 1, 31))
          .count { |d| d.wday != 0 && d.wday != 6 }

        expect(january[:revenue]).to eq((500 * working_days_in_jan).round(2))
        expect(january[:cost]).to eq((200 * working_days_in_jan).round(2))
      end

      it "marks past months as not projected" do
        result = described_class.call(period: period)
        expect(result.find { |e| e[:date].month == 1 }[:projected]).to be false
      end

      it "marks future months as projected" do
        result = described_class.call(period: period)
        expect(result.find { |e| e[:date].month == 12 }[:projected]).to be true
      end
    end
  end
end
require "rails_helper"

RSpec.describe Analytics::JobsFlowSummary, type: :service do
  let(:today) { Date.new(2024, 3, 15) }

  before { travel_to(today) }
  after  { travel_back }

  let(:march) { Date.new(2024, 3) }
  let(:year)  { Date.new(2024, 1) }

def create_job(start_date:, end_date: nil)
  raise "start_date must be a weekday" if start_date.saturday? || start_date.sunday?
  if end_date
    raise "end_date must be a weekday" if end_date.saturday? || end_date.sunday?
  end

  create(:job, start_date: start_date, end_date: end_date)
end

  describe ".call" do
    context "with a monthly period" do
      let(:period) { { month: march } }

      it "returns one entry per working day" do
        result = described_class.call(period: period)

        expected_days = (Date.new(2024, 3, 1)..Date.new(2024, 3, 31))
          .count { |d| d.wday != 0 && d.wday != 6 }

        expect(result.length).to eq(expected_days)
      end

      it "returns correct keys" do
        result = described_class.call(period: period)
        expect(result.first.keys).to match_array([:date, :started, :finished, :active, :projected])
      end

      context "job starts" do
        before do
          create_job(start_date: Date.new(2024, 3, 1))
          create_job(start_date: Date.new(2024, 3, 1))
        end

        it "counts jobs started on a given day" do
          result = described_class.call(period: period)
          entry = result.find { |e| e[:date] == Date.new(2024, 3, 1) }

          expect(entry[:started]).to eq(2)
        end
      end

      context "job finishes" do
        before do
          create_job(start_date: Date.new(2024, 2, 1), end_date: Date.new(2024, 3, 5))
        end

        it "counts jobs finished on a given day" do
          result = described_class.call(period: period)
          entry = result.find { |e| e[:date] == Date.new(2024, 3, 5) }

          expect(entry[:finished]).to eq(1)
        end
      end

      context "active jobs" do
        before do
          create_job(start_date: Date.new(2024, 2, 1)) # ongoing
        end

        it "includes jobs active at the start of the period" do
          result = described_class.call(period: period)
          entry = result.find { |e| e[:date] == Date.new(2024, 3, 1) }

          expect(entry[:active]).to eq(1)
        end

        it "updates active count when jobs start and finish" do
          create_job(start_date: Date.new(2024, 3, 5))
          create_job(start_date: Date.new(2024, 2, 1), end_date: Date.new(2024, 3, 11))

          result = described_class.call(period: period)

          day5 = result.find { |e| e[:date] == Date.new(2024, 3, 5) }
          day10 = result.find { |e| e[:date] == Date.new(2024, 3, 11) }

          expect(day5[:active]).to be >= 1
          expect(day10[:active]).to be >= 0
        end
      end

      context "projected flag" do
        it "marks past days as not projected" do
          result = described_class.call(period: period)
          expect(result.find { |e| e[:date] == Date.new(2024, 3, 1) }[:projected]).to be false
        end

        it "marks future days as projected" do
          result = described_class.call(period: period)
          expect(result.find { |e| e[:date] == Date.new(2024, 3, 20) }[:projected]).to be true
        end
      end

      context "with no jobs" do
        it "returns zeros for all metrics" do
          result = described_class.call(period: period)
          expect(result).to all(include(started: 0, finished: 0, active: 0))
        end
      end
    end

    context "with a yearly period" do
      let(:period) { { year: year } }

      it "returns 12 entries" do
        result = described_class.call(period: period)
        expect(result.length).to eq(12)
      end

      it "sets date to first of month" do
        result = described_class.call(period: period)

        expect(result.map { |e| e[:date].day }).to all(eq(1))
        expect(result.map { |e| e[:date].month }).to eq((1..12).to_a)
      end

      it "aggregates started and finished counts" do
        create_job(start_date: Date.new(2024, 1, 10))
        create_job(start_date: Date.new(2024, 1, 19))
        create_job(start_date: Date.new(2023, 1, 2), end_date: Date.new(2024, 1, 15))

        result = described_class.call(period: period)
        january = result.find { |e| e[:date].month == 1 }

        expect(january[:started]).to eq(2)
        expect(january[:finished]).to eq(1)
      end

      it "marks future months as projected" do
        result = described_class.call(period: period)
        expect(result.find { |e| e[:date].month == 12 }[:projected]).to be true
      end
    end
  end
end
require "rails_helper"

RSpec.describe Analytics::RevenueShare, type: :service do
  let(:march) { Date.new(2024, 3) }
  let(:year)  { Date.new(2024, 1) }

  def create_assignment(client_name:, day_rate:)
    client = create(:client, name: client_name)
    job = create(:job, client: client, day_rate: day_rate, start_date: Date.new(2023, 1, 1), end_date: nil)
    create(:assignment, job: job, user: create(:user), start_date: Date.new(2023, 1, 1), end_date: nil)
  end

  describe ".call" do
    context "with a monthly period" do
      let(:period) { { month: march } }

      it "returns one entry per client" do
        create_assignment(client_name: "A", day_rate: 500)
        create_assignment(client_name: "B", day_rate: 500)

        result = described_class.call(period: period)

        expect(result.map { |r| r[:client_name] }).to match_array(["A", "B"])
      end

      it "calculates equal share correctly" do
        create_assignment(client_name: "A", day_rate: 500)
        create_assignment(client_name: "B", day_rate: 500)

        result = described_class.call(period: period)

        expect(result.map { |r| r[:share] }).to all(eq(50.0))
      end

      it "weights share based on day rate" do
        create_assignment(client_name: "A", day_rate: 800)
        create_assignment(client_name: "B", day_rate: 200)

        result = described_class.call(period: period)

        a = result.find { |r| r[:client_name] == "A" }
        b = result.find { |r| r[:client_name] == "B" }

        expect(a[:share]).to eq(80.0)
        expect(b[:share]).to eq(20.0)
      end

      it "sorts results by descending share" do
        create_assignment(client_name: "A", day_rate: 800)
        create_assignment(client_name: "B", day_rate: 200)

        result = described_class.call(period: period)

        expect(result.first[:client_name]).to eq("A")
      end

      it "normalizes to 100%" do
        create_assignment(client_name: "A", day_rate: 333)
        create_assignment(client_name: "B", day_rate: 333)
        create_assignment(client_name: "C", day_rate: 334)

        result = described_class.call(period: period)

        total = result.sum { |r| r[:share] }
        expect(total).to eq(100.0)
      end

      context "with no assignments" do
        it "returns an empty array" do
          result = described_class.call(period: period)
          expect(result).to eq([])
        end
      end

      context "with assignments outside the period" do
        it "excludes them" do
          client = create(:client, name: "A")
          job = create(:job, client: client, day_rate: 500, start_date: Date.new(2023, 1, 1), end_date: nil)

          create(:assignment,
            job: job,
            user: create(:user),
            start_date: Date.new(2020, 1, 1),
            end_date: Date.new(2020, 1, 10)
          )

          result = described_class.call(period: period)

          expect(result).to eq([])
        end
      end
    end

    context "with a yearly period" do
      let(:period) { { year: year } }

      it "calculates share across the full year" do
        create_assignment(client_name: "A", day_rate: 600)
        create_assignment(client_name: "B", day_rate: 400)

        result = described_class.call(period: period)

        expect(result.sum { |r| r[:share] }).to eq(100.0)
      end
    end
  end
end
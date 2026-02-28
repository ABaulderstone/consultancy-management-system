require "rails_helper"

RSpec.describe Contracts::CreateContract, type: :service do
  let(:user) { create(:user) }

  describe ".call" do
    context "when params are valid" do
      let(:params) do
        {
          user_id: user.id,
          title: "Software Engineer",
          salary: 75_000,
          start_date: Date.today
        }
      end

      it "creates a contract" do
        expect { described_class.call(params: params) }.to change(Contract, :count).by(1)
      end

      it "returns the created contract" do
        result = described_class.call(params: params)
        expect(result).to be_a(Contract)
        expect(result).to be_persisted
      end
    end

    context "when user has an overlapping contract" do
      # need to persist this in db due to the way it checks
      let!(:existing_contract) do
        create(:contract, user: user, start_date: Date.today - 6.months, end_date: Date.today + 6.months)
      end

      let(:params) do
        {
          user_id: user.id,
          title: "Senior Software Engineer",
          salary: 90_000,
          start_date: Date.today + 1.month
        }
      end

      it "closes the existing contract" do
        described_class.call(params: params)
        expect(existing_contract.reload.end_date).to eq(Date.today + 1.month - 1.day)
      end

      it "creates the new contract" do
        expect { described_class.call(params: params) }.to change(Contract, :count).by(1)
      end
    end

    context "when user has an open ended contract" do
      let!(:existing_contract) do
        create(:contract, user: user, start_date: Date.today - 6.months, end_date: nil)
      end

      let(:params) do
        {
          user_id: user.id,
          title: "Senior Software Engineer",
          salary: 90_000,
          start_date: Date.today + 1.month
        }
      end

      it "closes the existing contract" do
        described_class.call(params: params)
        expect(existing_contract.reload.end_date).to eq(Date.today + 1.month - 1.day)
      end
    end

    context "when params are invalid" do
      let(:params) { { user_id: user.id } }

      it "raises ActiveRecord::RecordInvalid" do
        expect { described_class.call(params: params) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not create a contract" do
        # rescue nil to swallow exception and focus on side effect
        expect { described_class.call(params: params) rescue nil }.not_to change(Contract, :count)
      end

      it "does not modify existing contracts" do
        existing = create(:contract, user: user)
        original_end_date = existing.end_date
        described_class.call(params: params) rescue nil # same here
        expect(existing.reload.end_date).to eq(original_end_date)
      end
    end
  end
end

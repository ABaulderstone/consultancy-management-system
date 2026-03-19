require "rails_helper"

RSpec.describe Contracts::CreateContract, type: :service do
  let(:user) { create(:user) }
  let(:position) { create(:position) }

  let(:valid_params) do
    {
      user_id: user.id,
      position_id: position.id,
      contract_type: :full_time,
      rate: 60_000,
      fte: 1.0,
      start_date: Date.today
    }
  end

  describe ".call" do
    context "when params are valid" do
      it "creates a contract" do
        expect { described_class.call(params: valid_params) }.to change(Contract, :count).by(1)
      end

      it "returns the created contract" do
        result = described_class.call(params: valid_params)
        expect(result).to be_a(Contract)
        expect(result).to be_persisted
      end

      it "sets the correct attributes" do
        result = described_class.call(params: valid_params)
        expect(result.rate).to eq(60_000)
        expect(result.contract_type).to eq("full_time")
        expect(result.fte).to eq(1.0)
        expect(result.position).to eq(position)
      end
    end

    context "when user has an overlapping contract" do
      let!(:existing_contract) do
        create(:contract, user: user, start_date: Date.today - 6.months, end_date: Date.today + 6.months)
      end

      let(:params) do
        valid_params.merge(start_date: Date.today + 1.month)
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
        valid_params.merge(start_date: Date.today + 1.month)
      end

      it "closes the existing contract" do
        described_class.call(params: params)
        expect(existing_contract.reload.end_date).to eq(Date.today + 1.month - 1.day)
      end
    end

    context "for a contractor" do
      let(:contractor_params) do
        valid_params.merge(contract_type: :contractor, fte: nil, rate: 600)
      end

      it "creates a contractor contract without fte" do
        result = described_class.call(params: contractor_params)
        expect(result.fte).to be_nil
        expect(result.contractor?).to be true
      end
    end

    context "when params are invalid" do
      let(:invalid_params) { { user_id: user.id } }

      it "raises ActiveRecord::RecordInvalid" do
        expect { described_class.call(params: invalid_params) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not create a contract" do
        expect { described_class.call(params: invalid_params) rescue nil }.not_to change(Contract, :count)
      end

      it "does not modify existing contracts" do
        existing = create(:contract, user: user)
        original_end_date = existing.end_date
        described_class.call(params: invalid_params) rescue nil
        expect(existing.reload.end_date).to eq(original_end_date)
      end
    end

    context "when rate is outside salary band" do
      it "raises ActiveRecord::RecordInvalid" do
        params = valid_params.merge(rate: 200_000)
        expect { described_class.call(params: params) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not create a contract" do
        params = valid_params.merge(rate: 200_000)
        expect { described_class.call(params: params) rescue nil }.not_to change(Contract, :count)
      end
    end
  end
end

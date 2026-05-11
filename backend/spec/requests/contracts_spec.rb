require "rails_helper"
RSpec.describe "Contracts", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:employee) { create(:user) }
  let(:department) { create(:department) }
  let(:position) { create(:position, department: department) }
  let(:valid_params) do
    {
      user_id: employee.id,
      position_id: position.id,
      contract_type: :full_time,
      rate: 60_000,
      fte: 1.0,
      start_date: Date.today
    }
  end

  context "when admin" do
    let(:headers) { auth_headers(admin) }

    it "creates a contract" do
      expect {
        post "/contracts", params: valid_params, headers: headers
      }.to change(Contract, :count).by(1)
    end

    it "returns contract schema" do
      post "/contracts", params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
      expect(response).to match_response_schema("contract")
    end

    it "closes an existing open contract" do
      existing = create(:contract, user: employee, start_date: Date.today - 1.year, end_date: nil)
      post "/contracts", params: valid_params, headers: headers
      expect(existing.reload.end_date).to eq(Date.today - 1.day)
    end

    context "with invalid params" do
      it "returns error schema when rate is missing" do
        post "/contracts", params: valid_params.except(:rate), headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to match_response_schema("error")
        expect(json_response["details"]).to be_present
      end

      it "returns error schema when start_date is missing" do
        post "/contracts", params: valid_params.except(:start_date), headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to match_response_schema("error")
        expect(json_response["details"]).to be_present
      end
    end
  end

  context "when employee" do
    let(:headers) { auth_headers(employee) }

    it "returns forbidden" do
      post "/contracts", params: valid_params, headers: headers
      expect(response).to have_http_status(:forbidden)
      expect(response).to match_response_schema("error")
    end
  end

  context "when unauthenticated" do
    it "returns unauthorized" do
      post "/contracts", params: valid_params
      expect(response).to have_http_status(:unauthorized)
      expect(response).to match_response_schema("error")
    end
  end
end
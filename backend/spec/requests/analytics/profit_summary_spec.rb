require "rails_helper"

RSpec.describe "GET /analytics/profit_summary", type: :request do
  let(:admin)    { create(:user, :admin) }
  let(:employee) { create(:user) }

  describe "authentication and authorisation" do
    it "returns unauthorized when not authenticated" do
      get "/analytics/profit_summary"
      expect(response).to have_http_status(:unauthorized)
      expect(response).to match_response_schema("error")
    end

    it "returns forbidden for an employee" do
      get "/analytics/profit_summary", headers: auth_headers(employee)
      expect(response).to have_http_status(:forbidden)
      expect(response).to match_response_schema("error")
    end
  end

  describe "monthly view" do
    let(:headers) { auth_headers(admin) }

    it "returns ok" do
      get "/analytics/profit_summary", params: { month: "2024-03" }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "matches the profit_summary schema" do
      get "/analytics/profit_summary", params: { month: "2024-03" }, headers: headers
      expect(response).to match_response_schema("profit_summary")
    end

    it "returns one entry per working day in the month" do
      get "/analytics/profit_summary", params: { month: "2024-03" }, headers: headers
      expected = (Date.new(2024, 3, 1)..Date.new(2024, 3, 31)).count { |d| d.wday != 0 && d.wday != 6 }
      expect(json_response.length).to eq(expected)
    end

    it "defaults to the current month when no params given" do
      travel_to(Date.new(2024, 3, 15)) do
        get "/analytics/profit_summary", headers: headers
        dates = json_response.map { |e| Date.parse(e["date"]) }
        expect(dates.map(&:month).uniq).to eq([3])
        expect(dates.map(&:year).uniq).to eq([2024])
      end
    end

    it "returns 422 with an error schema for an invalid month" do
      get "/analytics/profit_summary", params: { month: "not-a-month" }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema("error")
    end

    it "includes the correct error message for an invalid month" do
      get "/analytics/profit_summary", params: { month: "not-a-month" }, headers: headers
      expect(json_response["message"]).to eq("Invalid month format. Use YYYY-MM.")
    end
  end

  describe "yearly view" do
    let(:headers) { auth_headers(admin) }

    it "returns ok" do
      get "/analytics/profit_summary", params: { year: "2024" }, headers: headers
      expect(response).to have_http_status(:ok)
    end

    it "matches the profit_summary schema" do
      get "/analytics/profit_summary", params: { year: "2024" }, headers: headers
      expect(response).to match_response_schema("profit_summary")
    end

    it "returns 12 entries" do
      get "/analytics/profit_summary", params: { year: "2024" }, headers: headers
      expect(json_response.length).to eq(12)
    end

    it "returns 422 with an error schema for an invalid year" do
      get "/analytics/profit_summary", params: { year: "not-a-year" }, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response).to match_response_schema("error")
    end

    it "includes the correct error message for an invalid year" do
      get "/analytics/profit_summary", params: { year: "not-a-year" }, headers: headers
      expect(json_response["message"]).to eq("Invalid year format. Use YYYY.")
    end
  end
end
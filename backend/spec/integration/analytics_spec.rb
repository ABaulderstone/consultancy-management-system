require "swagger_helper"

RSpec.describe "Analytics API", type: :request do
  let!(:admin)    { create(:user, :admin) }
  let!(:employee) { create(:user) }
  let(:admin_token)    { JwtService.encode(user_id: admin.id) }
  let(:employee_token) { JwtService.encode(user_id: employee.id) }
  let(:Authorization)  { "Bearer #{admin_token}" }

  path "/analytics/profit_summary" do
    get "Profit summary" do
      tags "Analytics"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      produces "application/json"

      parameter name: :month, in: :query, type: :string, required: false,
                description: "Month to summarise in YYYY-MM format. Returns one entry per working day."
      parameter name: :year, in: :query, type: :string, required: false,
                description: "Year to summarise in YYYY format. Returns one entry per month."

      response "200", "monthly profit summary" do
        let(:month) { "2024-03" }
        schema "$ref" => "#/components/schemas/profit_summary"
        run_test!
      end

      response "200", "yearly profit summary" do
        let(:year) { "2024" }
        schema "$ref" => "#/components/schemas/profit_summary"
        run_test!
      end

      response "200", "defaults to current month when no params given" do
        schema "$ref" => "#/components/schemas/profit_summary"
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "403", "forbidden" do
        let(:Authorization) { "Bearer #{employee_token}" }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "422", "invalid month format" do
        let(:month) { "not-a-month" }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "422", "invalid year format" do
        let(:year) { "not-a-year" }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end
  end
end
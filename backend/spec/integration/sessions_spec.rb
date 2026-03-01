require "swagger_helper"

RSpec.describe "Sessions API", type: :request do
  let!(:user) { create(:user) }
  let(:token) { JwtService.encode(user_id: user.id) }
  let(:Authorization) { "Bearer #{token}" }

  path "/session" do
    get "Get current session" do
      tags "Sessions"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      produces "application/json"

      response "200", "session found" do
        schema "$ref" => "#/components/schemas/enriched_user"
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end

    post "Create session (login)" do
      tags "Sessions"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        required: [ "email", "password" ],
        properties: {
          email: { type: :string },
          password: { type: :string }
        }
      }

      response "200", "session created" do
        let(:params) { { email: user.email, password: "password123" } }
        schema "$ref" => "#/components/schemas/enriched_user"
        run_test!
      end

      response "401", "invalid credentials" do
        let(:params) { { email: user.email, password: "wrongpassword" } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end

    delete "Destroy session (logout)" do
      tags "Sessions"
      security [ bearerAuth: [] ]

      response "204", "session destroyed" do
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end
  end
end

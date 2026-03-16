require "swagger_helper"

RSpec.describe "Users API", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:employee) { create(:user) }
  let(:admin_token) { JwtService.encode(user_id: admin.id) }
  let(:employee_token) { JwtService.encode(user_id: employee.id) }
  let(:Authorization) { "Bearer #{admin_token}" }

  path "/users" do
    get "List all users" do
      tags "Users"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      produces "application/json"

        parameter name: :page, in: :query, type: :integer, required: false
        parameter name: :limit, in: :query, type: :integer, required: false
        parameter name: :sort, in: :query, type: :string, required: false,
                  enum: %w[first_name last_name email]
        parameter name: :direction, in: :query, type: :string, required: false,
                  enum: %w[asc desc]

      response "200", "users listed" do
        schema "$ref" => "#/components/schemas/paginated_users"
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
    end

    post "Create a user" do
      tags "Users"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        required: [ "first_name", "last_name" ],
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          date_of_birth: { type: :string },
          gender: { type: :string }
        }
      }

      response "201", "user created" do
        let(:params) { { first_name: "John", last_name: "Smith", date_of_birth: "1990-01-01", gender: "male" } }
        schema "$ref" => "#/components/schemas/enriched_user"
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        let(:params) { { first_name: "John", last_name: "Smith" } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "403", "forbidden" do
        let(:Authorization) { "Bearer #{employee_token}" }
        let(:params) { { first_name: "John", last_name: "Smith" } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "422", "validation failed" do
        let(:params) { { first_name: "John" } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end
  end

  path "/users/{id}" do
    parameter name: :id, in: :path, type: :integer

    get "Get a user" do
      tags "Users"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      produces "application/json"

      response "200", "user found" do
        let(:id) { employee.id }
        schema "$ref" => "#/components/schemas/enriched_user"
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        let(:id) { employee.id }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "403", "forbidden" do
        let(:Authorization) { "Bearer #{employee_token}" }
        let(:id) { create(:user).id }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end

    patch "Update a user" do
      tags "Users"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          date_of_birth: { type: :string },
          gender: { type: :string },
          title: { type: :string }
        }
      }

      response "200", "user updated" do
        let(:id) { employee.id }
        let(:params) { { first_name: "Jane", last_name: "Doe" } }
        schema "$ref" => "#/components/schemas/enriched_user"
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        let(:id) { employee.id }
        let(:params) { { first_name: "Jane" } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "403", "forbidden" do
        let(:Authorization) { "Bearer #{employee_token}" }
        let(:id) { create(:user).id }
        let(:params) { { first_name: "Jane" } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "422", "validation failed" do
        let(:id) { employee.id }
        let(:params) { { first_name: nil, last_name: nil } }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end

    delete "Delete a user" do
      tags "Users"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]

      response "204", "user deleted" do
        let(:id) { employee.id }
        run_test!
      end

      response "401", "unauthorized" do
        let(:Authorization) { nil }
        let(:id) { employee.id }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end

      response "403", "forbidden" do
        let(:Authorization) { "Bearer #{employee_token}" }
        let(:id) { employee.id }
        schema "$ref" => "#/components/schemas/error"
        run_test!
      end
    end
  end

  path "/users/current" do
    get "Get current user" do
      tags "Users"
      security [ { bearerAuth: [] }, { cookieAuth: [] } ]
      produces "application/json"

      response "200", "current user returned" do
        let(:Authorization) { "Bearer #{employee_token}" }
        schema "$ref" => "#/components/schemas/enriched_user"
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

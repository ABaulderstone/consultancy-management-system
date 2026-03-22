require "rails_helper"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "API V1",
        version: "v1",
        description: "HR Management API"
      },
      paths: {},
      servers: [
        {
          url: "http://localhost:3000",
          description: "Development server"
        }
      ],
      components: {
       securitySchemes: {
          bearerAuth: {
            type: :http,
            scheme: :bearer
              },
          cookieAuth: {
            type: :apiKey,
            in: :cookie,
            name: :jwt
              }
            },
        schemas: {
          error: {
            type: :object,
            required: [ "status", "error", "message", "path", "timestamp" ],
            properties: {
              status: { type: :integer },
              error: { type: :string },
              message: { type: :string },
              path: { type: :string },
              timestamp: { type: :string },
              details: {
                type: :object,
                additionalProperties: {
                  type: :array,
                  items: { type: :string }
                }
              }
            }
          },
          user: {
              type: :object,
              required: [ "id", "email", "role", "employment_status" ],
              properties: {
                id: { type: :integer },
                email: { type: :string },
                role: { type: :string, enum: [ "employee", "admin" ] },
                first_name: { type: :string, nullable: true },
                last_name: { type: :string, nullable: true },
                title: { type: :string, nullable: true },
                gender: { type: :string, nullable: true },
                date_of_birth: { type: :string, nullable: true },
                employment_status: { type: :string, enum: [ "active", "departed", "uncontracted" ] },
                assignment_status: { type: :string, nullable: true, enum: [ "assigned", "bench", nil ] }
              }
            },
            user_profile: {
              type: :object,
              required: [ "id", "email", "role", "employment_status" ],
              properties: {
                id: { type: :integer },
                email: { type: :string },
                role: { type: :string, enum: [ "employee", "admin" ] },
                first_name: { type: :string, nullable: true },
                last_name: { type: :string, nullable: true },
                title: { type: :string, nullable: true },
                gender: { type: :string, nullable: true },
                date_of_birth: { type: :string, nullable: true },
                employment_status: { type: :string, enum: [ "active", "departed", "uncontracted" ] },
                assignment_status: { type: :string, nullable: true, enum: [ "assigned", "bench", nil ] },
                lifetime_utilisation: { type: :number, nullable: true },
                current_contract: {
                  type: :object,
                  nullable: true,
                  properties: {
                    contract_type: { type: :string, enum: [ "full_time", "part_time", "contractor" ] },
                    rate: { type: :number },
                    payable_rate: { type: :number },
                    daily_cost: { type: :number },
                    fte: { type: :number, nullable: true },
                    start_date: { type: :string },
                    position: {
                      type: :object,
                      properties: {
                        title: { type: :string },
                        department: { type: :string }
                      }
                    }
                  }
                },
                current_job: {
                  type: :object,
                  nullable: true,
                  properties: {
                    title: { type: :string },
                    client: { type: :string },
                    start_date: { type: :string },
                    day_rate: { type: :number },
                    daily_margin: { type: :number }
                  }
                }
              }
            },
            paginated_users: {
              type: :object,
              required: [ "data", "meta", "links" ],
              properties: {
                data: {
                  type: :array,
                  items: { "$ref" => "#/components/schemas/user" }
                },
              meta: {
                type: :object,
                required: [ "page", "limit", "pages", "count" ],
                properties: {
                  page: { type: :integer },
                  limit: { type: :integer },
                  pages: { type: :integer },
                  count: { type: :integer }
                }
              },
              links: {
                type: :object,
                properties: {
                  next: { type: :string, nullable: true },
                  prev: { type: :string, nullable: true }
                }
              }
            }
          }
        }
      }
    }
  }

  config.openapi_format = :yaml
end

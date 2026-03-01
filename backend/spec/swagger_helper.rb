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
          enriched_user: {
            type: :object,
            required: [ "id", "email", "first_name", "last_name" ],
            properties: {
              id: { type: :integer },
              email: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              title: { type: :string, nullable: true },
              gender: { type: :string, nullable: true },
              date_of_birth: { type: :string, nullable: true },
              age: { type: :integer, nullable: true }
            }
          },
          paginated_users: {
            type: :object,
            required: [ "data", "meta", "links" ],
            properties: {
              data: {
                type: :array,
                items: { "$ref" => "#/components/schemas/enriched_user" }
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

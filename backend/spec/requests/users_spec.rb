require "rails_helper"

RSpec.describe "Users", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:employee) { create(:user) }

  describe "GET /users" do
    it "debug" do
    get "/users"
    puts Rails.env
    puts response.status
    puts response.body
  end

    context "when admin" do
      let(:headers) { auth_headers(admin) }

      it "returns paginated response" do
        create_list(:user, 3)
        get "/users", headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("paginated_response")
      end

      it "returns user schema for each record" do
        get "/users", headers: headers
        expect(json_response["data"].first).to match_response_schema("user")
      end

      it "returns paginated response" do
        create_list(:user, 3)
        get "/users", headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("paginated_response")
      end

      it "returns user schema for each record" do
        get "/users", headers: headers
        expect(json_response["data"].first).to match_response_schema("user")
      end

      context "with sort params" do
        it "sorts by first_name asc" do
          zara = create(:user)
          zara.profile.update!(first_name: "Zara")
          aaron = create(:user)
          aaron.profile.update!(first_name: "Aaron")
          get "/users", params: { sort: "first_name", direction: "asc" }, headers: headers
          expect(response).to have_http_status(:ok)
          expect(json_response["data"].first["first_name"]).to eq("Aaron")
          expect(json_response["data"].last["first_name"]).to eq("Zara")
        end

        it "sorts by first_name desc" do
          zara = create(:user)
          zara.profile.update!(first_name: "Zara")
          aaron = create(:user)
          aaron.profile.update!(first_name: "Aaron")
          get "/users", params: { sort: "first_name", direction: "desc" }, headers: headers
          expect(response).to have_http_status(:ok)
          expect(json_response["data"].first["first_name"]).to eq("Zara")
          expect(json_response["data"].last["first_name"]).to eq("Aaron")
        end

        it "ignores invalid sort column and defaults to id" do
          get "/users", params: { sort: "malicious_input", direction: "asc" }, headers: headers
          expect(response).to have_http_status(:ok)
        end

        it "ignores invalid direction and defaults to asc" do
          get "/users", params: { sort: "first_name", direction: "invalid" }, headers: headers
          expect(response).to have_http_status(:ok)
        end
      end
    end


    context "when employee" do
      let(:headers) { auth_headers(employee) }

      it "returns error schema" do
        get "/users", headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(response).to match_response_schema("error")
      end
    end

    context "when unauthenticated" do
      it "returns error schema" do
        get "/users"
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end
  end

  describe "GET /users/:id" do
    context "when admin" do
      let(:headers) { auth_headers(admin) }

      it "returns user profile schema" do
        get "/users/#{employee.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_profile")
      end
    end

    context "when same user" do
      let(:headers) { auth_headers(employee) }

      it "returns user profile schema" do
        get "/users/#{employee.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_profile")
      end
    end

    context "when different employee" do
      let(:other) { create(:user) }
      let(:headers) { auth_headers(employee) }

      it "returns error schema" do
        get "/users/#{other.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(response).to match_response_schema("error")
      end
    end

    context "when unauthenticated" do
      it "returns error schema" do
        get "/users/#{employee.id}"
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end
  end

  describe "POST /users" do
    let(:params) do
      {
        first_name: "John",
        last_name: "Smith",
        date_of_birth: "1990-01-01",
        gender: "male"
      }
    end

    context "when admin" do
      let(:headers) { auth_headers(admin) }

      it "creates a user" do
        expect { post "/users", params: params, headers: headers }.to change(User, :count).by(1)
      end

      it "returns user profile schema" do
        post "/users", params: params, headers: headers
        expect(response).to have_http_status(:created)
        expect(response).to match_response_schema("user_profile")
      end
    end

    context "when employee" do
      let(:headers) { auth_headers(employee) }

      it "returns error schema" do
        post "/users", params: params, headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(response).to match_response_schema("error")
      end
    end

    context "with invalid params" do
      let(:headers) { auth_headers(admin) }

      it "returns error schema" do
        post "/users", params: { first_name: "John" }, headers: headers
        expect(response).to match_response_schema("error")
        expect(response).to have_http_status(:unprocessable_content)
        expect(json_response["details"]).to be_present
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        post "/users", params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /users/:id" do
    let(:params) { { first_name: "Jane", last_name: "Doe" } }

    context "when admin" do
      let(:headers) { auth_headers(admin) }

      it "updates the user" do
        patch "/users/#{employee.id}", params: params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(employee.profile.reload.first_name).to eq("Jane")
      end

      it "returns user profile schema" do
        patch "/users/#{employee.id}", params: params, headers: headers
        expect(response).to match_response_schema("user_profile")
      end
    end

    context "when same user" do
      let(:headers) { auth_headers(employee) }

      it "returns user profile schema" do
        patch "/users/#{employee.id}", params: params, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_profile")
      end
    end

    context "when different employee" do
      let(:other) { create(:user) }
      let(:headers) { auth_headers(employee) }

      it "returns error schema" do
        patch "/users/#{other.id}", params: params, headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(response).to match_response_schema("error")
      end
    end

    context "with invalid params" do
      let(:headers) { auth_headers(admin) }

      it "returns error schema" do
        patch "/users/#{employee.id}", params: { first_name: nil, last_name: nil }, headers: headers
        expect(response).to have_http_status(:unprocessable_content)
        expect(response).to match_response_schema("error")
        expect(json_response["details"]).to be_present
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        patch "/users/#{employee.id}", params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /users/:id" do
    context "when admin" do
      let(:headers) { auth_headers(admin) }

      it "deletes the user" do
        expect { delete "/users/#{employee.id}", headers: headers }.to change(User, :count).by(-1)
      end

      it "returns no content" do
        delete "/users/#{employee.id}", headers: headers
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when employee" do
      let(:headers) { auth_headers(employee) }

      it "returns error schema" do
        delete "/users/#{employee.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(response).to match_response_schema("error")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        delete "/users/#{employee.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /users/current" do
    context "when authenticated" do
      let(:headers) { auth_headers(employee) }

      it "returns ok" do
        get "/users/current", headers: headers
        expect(response).to have_http_status(:ok)
      end

      it "returns  user schema" do
        get "/users/current", headers: headers
        expect(response).to match_response_schema("user")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        get "/users/current"
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error schema" do
        get "/users/current"
        expect(response).to match_response_schema("error")
      end
    end
  end
  describe "GET /users/:id/contracts" do
  context "when admin" do
    let(:headers) { auth_headers(admin) }
    let(:nonexistent_id) { User.maximum(:id) + 1 }

    it "returns contracts for the user" do
      create(:contract, user: employee)
      get "/users/#{employee.id}/contracts", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_response).to be_an(Array)
    end

    it "returns contracts in descending order by start date" do
      older = create(:contract, user: employee, start_date: Date.today - 2.years, end_date: Date.today - 1.year)
      newer = create(:contract, user: employee, start_date: Date.today - 6.months, end_date: nil)
      get "/users/#{employee.id}/contracts", headers: headers
      expect(json_response.first["id"]).to eq(newer.id)
      expect(json_response.last["id"]).to eq(older.id)
    end

    it "returns contract schema for each record" do
      create(:contract, user: employee)
      get "/users/#{employee.id}/contracts", headers: headers
      expect(json_response.first).to match_response_schema("contract")
    end

    it "returns 404 for non existent user" do
      get "/users/#{nonexistent_id}/contracts", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  context "when employee" do
    let(:headers) { auth_headers(employee) }

    it "returns forbidden" do
      get "/users/#{employee.id}/contracts", headers: headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "when unauthenticated" do
    it "returns unauthorized" do
      get "/users/#{employee.id}/contracts"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

  describe "GET /users/:id/assignments" do
    context "when admin" do
      let(:headers) { auth_headers(admin) }
      let(:nonexistent_id) { User.maximum(:id) + 1 }

      it "returns assignments for the user" do
        create(:assignment, user: employee)
        get "/users/#{employee.id}/assignments", headers: headers
        expect(response).to have_http_status(:ok)
        expect(json_response).to be_an(Array)
      end

      it "returns assignments in descending order by start date" do
        older = create(:assignment, user: employee, start_date: Date.today - 2.years, end_date: Date.today - 1.year)
        newer = create(:assignment, user: employee, start_date: Date.today - 6.months, end_date: nil)
        get "/users/#{employee.id}/assignments", headers: headers
        expect(json_response.first["id"]).to eq(newer.id)
        expect(json_response.last["id"]).to eq(older.id)
      end

      it "returns assignment schema for each record" do
        create(:assignment, user: employee)
        get "/users/#{employee.id}/assignments", headers: headers
        expect(json_response.first).to match_response_schema("assignment")
      end

      it "returns 404 for non existent user" do
        get "/users/#{nonexistent_id}/assignments", headers: headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when employee" do
      let(:headers) { auth_headers(employee) }

      it "returns forbidden" do
        get "/users/#{employee.id}/assignments", headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        get "/users/#{employee.id}/assignments"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

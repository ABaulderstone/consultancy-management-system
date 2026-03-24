require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user) }

  describe "GET /session" do
    context "when authenticated" do
      let(:headers) { auth_headers(user) }



      it "returns user profile schema" do
        get "/session", headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_profile")
      end
    end

    context "when unauthenticated" do
      it "returns error schema" do
        get "/session"
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end
  end

  describe "POST /session" do
    context "with valid credentials" do
      it "returns enriched user schema" do
        post "/session", params: { email: user.email, password: "password123" }
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("user_profile")
      end

      it "sets a jwt cookie" do
        post "/session", params: { email: user.email, password: "password123" }
        expect(cookies["jwt"]).to be_present
      end
    end

    context "with invalid password" do
      it "returns error schema" do
        post "/session", params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end

    context "with unknown email" do
      it "returns error schema" do
        post "/session", params: { email: "unknown@example.com", password: "password123" }
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end
  end

  describe "DELETE /session" do
    context "when authenticated" do
      let(:headers) { auth_headers(user) }

      it "returns no content" do
        delete "/session", headers: headers
        expect(response).to have_http_status(:no_content)
      end

      it "clears the jwt cookie" do
        delete "/session", headers: headers
        expect(cookies["jwt"]).to be_blank
      end
    end

    context "when unauthenticated" do
      it "returns error schema" do
        delete "/session"
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end
  end
end

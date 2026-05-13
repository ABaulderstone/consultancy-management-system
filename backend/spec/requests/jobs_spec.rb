require "rails_helper"

RSpec.describe "Jobs", type: :request do
  let!(:admin) { create(:user, :admin) }
  let!(:employee) { create(:user) }

  describe "GET /jobs" do
    context "when admin" do
      let(:headers) { auth_headers(admin) }

      it "returns paginated response" do
        create_list(:job, 3)
        get "/jobs", headers: headers
        expect(response).to have_http_status(:ok)
        expect(response).to match_response_schema("paginated_response")
      end

      it "returns job schema for each record" do
        create(:job)
        get "/jobs", headers: headers
        expect(json_response["data"].first).to match_response_schema("job")
      end

      context "with status filter" do
        let!(:open_job) { create(:job, end_date: nil) }
        let!(:closed_job) { create(:job, end_date: 1.week.ago, start_date: 2.months.ago) }
        let!(:assigned_job) do
          job = create(:job, end_date: nil)
          create(:assignment, job: job, user: employee, start_date: 1.week.ago, end_date: nil)
          job
        end

        it "returns only open jobs" do
          get "/jobs", params: { status: "open" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(open_job.id)
          expect(ids).not_to include(assigned_job.id, closed_job.id)
        end

        it "returns only assigned jobs" do
          get "/jobs", params: { status: "assigned" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(assigned_job.id)
          expect(ids).not_to include(open_job.id, closed_job.id)
        end

        it "returns only closed jobs" do
          get "/jobs", params: { status: "closed" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(closed_job.id)
          expect(ids).not_to include(open_job.id, assigned_job.id)
        end

        it "returns all jobs when no status filter given" do
          get "/jobs", headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(open_job.id, assigned_job.id, closed_job.id)
        end
      end

      context "with search" do
        let!(:rails_job) { create(:job, title: "Senior Rails Engineer") }
        let!(:design_job) { create(:job, title: "Product Designer") }
        let!(:acme_job) { create(:job, client: create(:client, name: "Acme Corp")) }
        let!(:assigned_job) do
          job = create(:job)
          user = create(:user)
          user.profile.update!(first_name: "Margaret", last_name: "Thatcher")
          create(:assignment, job: job, user: user, start_date: 1.week.ago, end_date: nil)
          job
        end

        it "returns jobs matching title" do
          get "/jobs", params: { search: "Rails" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(rails_job.id)
          expect(ids).not_to include(design_job.id)
        end

        it "returns jobs matching client name" do
          get "/jobs", params: { search: "Acme" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(acme_job.id)
          expect(ids).not_to include(rails_job.id)
        end

        it "returns jobs matching assigned user name" do
          get "/jobs", params: { search: "Margaret" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(assigned_job.id)
        end

        it "is case insensitive" do
          get "/jobs", params: { search: "rails" }, headers: headers
          ids = json_response["data"].map { |j| j["id"] }
          expect(ids).to include(rails_job.id)
        end

        it "returns empty data when no matches" do
          get "/jobs", params: { search: "zzznomatch" }, headers: headers
          expect(json_response["data"]).to be_empty
        end
      end
    end

    context "when employee" do
      let(:headers) { auth_headers(employee) }

      it "returns forbidden" do
        get "/jobs", headers: headers
        expect(response).to have_http_status(:forbidden)
        expect(response).to match_response_schema("error")
      end
    end

    context "when unauthenticated" do
      it "returns unauthorized" do
        get "/jobs"
        expect(response).to have_http_status(:unauthorized)
        expect(response).to match_response_schema("error")
      end
    end
  end
end
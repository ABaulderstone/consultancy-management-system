require "rails_helper"

RSpec.describe Users::UpdateUser, type: :service do
  let(:user) { create(:user) }

  describe ".call" do
    context "when updating name" do
      let(:params) do
        {
          first_name: "Jane",
          last_name: "Doe"
        }
      end

      it "updates the profile" do
        described_class.call(user: user, params: params)
        expect(user.profile.reload.first_name).to eq("Jane")
        expect(user.profile.reload.last_name).to eq("Doe")
      end

      it "regenerates the email" do
        described_class.call(user: user, params: params)
        expect(user.reload.email).to match(/jane\.doe\.\d{4}@example\.com/)
      end
    end

    context "when name has not changed" do
      let(:params) do
        {
          first_name: user.profile.first_name,
          last_name: user.profile.last_name,
          date_of_birth: "1995-06-15"
        }
      end

      it "does not change the email" do
        original_email = user.email
        described_class.call(user: user, params: params)
        expect(user.reload.email).to eq(original_email)
      end

      it "updates other profile fields" do
        described_class.call(user: user, params: params)
        expect(user.profile.reload.date_of_birth).to eq(Date.parse("1995-06-15"))
      end
    end

    context "when params are invalid" do
      let(:params) { { first_name: nil, last_name: nil } }

      it "raises ActiveRecord::RecordInvalid" do
        expect { described_class.call(user: user, params: params) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not update the user" do
        original_email = user.email
        described_class.call(user: user, params: params) rescue nil
        expect(user.reload.email).to eq(original_email)
      end
    end
  end
end

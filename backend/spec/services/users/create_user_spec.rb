require "rails_helper"

RSpec.describe Users::CreateUser, type: :service do
  let(:params) do
    {
      first_name: "John",
      last_name: "Smith",
      date_of_birth: "1990-01-01",
      gender: :male
    }
  end

  describe ".call" do
    context "when params are valid" do
      it "creates a user" do
        expect { described_class.call(params: params) }.to change(User, :count).by(1)
      end

      it "creates a profile" do
        expect { described_class.call(params: params) }.to change(Profile, :count).by(1)
      end

      it "generates an email from the user's name and id" do
        result = described_class.call(params: params)
        expect(result[:user].email).to match(/john\.smith\.\d{4}@example\.com/)
      end

      it "returns the user and password" do
        result = described_class.call(params: params)
        expect(result[:user]).to be_a(User)
        expect(result[:password]).to be_present
      end

      it "generates a password of 12 characters" do
        result = described_class.call(params: params)
        expect(result[:password].length).to eq(12)
      end
    end

    context "when params are invalid" do
      let(:params) { { first_name: "John" } }

      it "raises ActiveRecord::RecordInvalid" do
        expect { described_class.call(params: params) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not create a user" do
        expect { described_class.call(params: params) rescue nil }.not_to change(User, :count)
      end

      it "does not create a profile" do
        expect { described_class.call(params: params) rescue nil }.not_to change(Profile, :count)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Client, type: :model do
  subject { build(:client) }

  describe "associations" do
    it { should have_many(:jobs).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end

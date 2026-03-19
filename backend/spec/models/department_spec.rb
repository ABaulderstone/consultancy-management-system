require 'rails_helper'


RSpec.describe Department, type: :model do
  subject { build(:department) }

  describe "associations" do
    it { should have_many(:positions).dependent(:restrict_with_error) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_inclusion_of(:billable).in_array([true, false]) }
  end
end
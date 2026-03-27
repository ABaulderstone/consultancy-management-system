require 'rails_helper'

RSpec.describe SlugHistory, type: :model do
  describe "validations" do
   it { should validate_presence_of(:slug) }
   it { should validate_presence_of(:expires_at) }
 end
end

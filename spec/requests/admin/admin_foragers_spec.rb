require 'spec_helper'

describe "Admin::Foragers" do
  describe "GET /admin_foragers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get admin_foragers_path
      response.status.should be(200)
    end
  end
end

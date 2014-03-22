require "spec_helper"

describe ClaimsController do
  describe "routing" do

    it "routes to #index" do
      get("/claims").should route_to("claims#index")
    end

    it "routes to #new" do
      get("/claims/new").should route_to("claims#new")
    end

    it "routes to #show" do
      get("/claims/1").should route_to("claims#show", :id => "1")
    end

    it "routes to #edit" do
      get("/claims/1/edit").should route_to("claims#edit", :id => "1")
    end

    it "routes to #create" do
      post("/claims").should route_to("claims#create")
    end

    it "routes to #update" do
      put("/claims/1").should route_to("claims#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/claims/1").should route_to("claims#destroy", :id => "1")
    end

  end
end

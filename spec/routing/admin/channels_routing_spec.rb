require "spec_helper"

describe Admin::ChannelsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/channels").should route_to("admin/channels#index")
    end

    it "routes to #new" do
      get("/admin/channels/new").should route_to("admin/channels#new")
    end

    it "routes to #show" do
      get("/admin/channels/1").should route_to("admin/channels#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/channels/1/edit").should route_to("admin/channels#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/channels").should route_to("admin/channels#create")
    end

    it "routes to #update" do
      put("/admin/channels/1").should route_to("admin/channels#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/channels/1").should route_to("admin/channels#destroy", :id => "1")
    end

  end
end

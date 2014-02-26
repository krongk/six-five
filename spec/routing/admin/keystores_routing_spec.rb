require "spec_helper"

describe Admin::KeystoresController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/keystores").should route_to("admin/keystores#index")
    end

    it "routes to #new" do
      get("/admin/keystores/new").should route_to("admin/keystores#new")
    end

    it "routes to #show" do
      get("/admin/keystores/1").should route_to("admin/keystores#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/keystores/1/edit").should route_to("admin/keystores#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/keystores").should route_to("admin/keystores#create")
    end

    it "routes to #update" do
      put("/admin/keystores/1").should route_to("admin/keystores#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/keystores/1").should route_to("admin/keystores#destroy", :id => "1")
    end

  end
end

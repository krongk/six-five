require "spec_helper"

describe Admin::ForagersController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/foragers").should route_to("admin/foragers#index")
    end

    it "routes to #new" do
      get("/admin/foragers/new").should route_to("admin/foragers#new")
    end

    it "routes to #show" do
      get("/admin/foragers/1").should route_to("admin/foragers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/foragers/1/edit").should route_to("admin/foragers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/foragers").should route_to("admin/foragers#create")
    end

    it "routes to #update" do
      put("/admin/foragers/1").should route_to("admin/foragers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/foragers/1").should route_to("admin/foragers#destroy", :id => "1")
    end

  end
end

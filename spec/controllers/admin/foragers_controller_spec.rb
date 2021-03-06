require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Admin::ForagersController do

  # This should return the minimal set of attributes required to create a valid
  # Admin::Forager. As you add validations to Admin::Forager, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "is_migrated" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # Admin::ForagersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all admin_foragers as @admin_foragers" do
      forager = Admin::Forager.create! valid_attributes
      get :index, {}, valid_session
      assigns(:admin_foragers).should eq([forager])
    end
  end

  describe "GET show" do
    it "assigns the requested admin_forager as @admin_forager" do
      forager = Admin::Forager.create! valid_attributes
      get :show, {:id => forager.to_param}, valid_session
      assigns(:admin_forager).should eq(forager)
    end
  end

  describe "GET new" do
    it "assigns a new admin_forager as @admin_forager" do
      get :new, {}, valid_session
      assigns(:admin_forager).should be_a_new(Admin::Forager)
    end
  end

  describe "GET edit" do
    it "assigns the requested admin_forager as @admin_forager" do
      forager = Admin::Forager.create! valid_attributes
      get :edit, {:id => forager.to_param}, valid_session
      assigns(:admin_forager).should eq(forager)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Admin::Forager" do
        expect {
          post :create, {:admin_forager => valid_attributes}, valid_session
        }.to change(Admin::Forager, :count).by(1)
      end

      it "assigns a newly created admin_forager as @admin_forager" do
        post :create, {:admin_forager => valid_attributes}, valid_session
        assigns(:admin_forager).should be_a(Admin::Forager)
        assigns(:admin_forager).should be_persisted
      end

      it "redirects to the created admin_forager" do
        post :create, {:admin_forager => valid_attributes}, valid_session
        response.should redirect_to(Admin::Forager.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin_forager as @admin_forager" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Forager.any_instance.stub(:save).and_return(false)
        post :create, {:admin_forager => { "is_migrated" => "invalid value" }}, valid_session
        assigns(:admin_forager).should be_a_new(Admin::Forager)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Forager.any_instance.stub(:save).and_return(false)
        post :create, {:admin_forager => { "is_migrated" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested admin_forager" do
        forager = Admin::Forager.create! valid_attributes
        # Assuming there are no other admin_foragers in the database, this
        # specifies that the Admin::Forager created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Admin::Forager.any_instance.should_receive(:update).with({ "is_migrated" => "MyString" })
        put :update, {:id => forager.to_param, :admin_forager => { "is_migrated" => "MyString" }}, valid_session
      end

      it "assigns the requested admin_forager as @admin_forager" do
        forager = Admin::Forager.create! valid_attributes
        put :update, {:id => forager.to_param, :admin_forager => valid_attributes}, valid_session
        assigns(:admin_forager).should eq(forager)
      end

      it "redirects to the admin_forager" do
        forager = Admin::Forager.create! valid_attributes
        put :update, {:id => forager.to_param, :admin_forager => valid_attributes}, valid_session
        response.should redirect_to(forager)
      end
    end

    describe "with invalid params" do
      it "assigns the admin_forager as @admin_forager" do
        forager = Admin::Forager.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Forager.any_instance.stub(:save).and_return(false)
        put :update, {:id => forager.to_param, :admin_forager => { "is_migrated" => "invalid value" }}, valid_session
        assigns(:admin_forager).should eq(forager)
      end

      it "re-renders the 'edit' template" do
        forager = Admin::Forager.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Admin::Forager.any_instance.stub(:save).and_return(false)
        put :update, {:id => forager.to_param, :admin_forager => { "is_migrated" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested admin_forager" do
      forager = Admin::Forager.create! valid_attributes
      expect {
        delete :destroy, {:id => forager.to_param}, valid_session
      }.to change(Admin::Forager, :count).by(-1)
    end

    it "redirects to the admin_foragers list" do
      forager = Admin::Forager.create! valid_attributes
      delete :destroy, {:id => forager.to_param}, valid_session
      response.should redirect_to(admin_foragers_url)
    end
  end

end

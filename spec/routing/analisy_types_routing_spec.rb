require "rails_helper"

RSpec.describe AnalisyTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/analisy_types").to route_to("analisy_types#index")
    end

    it "routes to #new" do
      expect(:get => "/analisy_types/new").to route_to("analisy_types#new")
    end

    it "routes to #show" do
      expect(:get => "/analisy_types/1").to route_to("analisy_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/analisy_types/1/edit").to route_to("analisy_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/analisy_types").to route_to("analisy_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/analisy_types/1").to route_to("analisy_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/analisy_types/1").to route_to("analisy_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/analisy_types/1").to route_to("analisy_types#destroy", :id => "1")
    end

  end
end

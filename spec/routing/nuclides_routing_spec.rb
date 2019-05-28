require "rails_helper"

RSpec.describe NuclidesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/nuclides").to route_to("nuclides#index")
    end

    it "routes to #new" do
      expect(:get => "/nuclides/new").to route_to("nuclides#new")
    end

    it "routes to #show" do
      expect(:get => "/nuclides/1").to route_to("nuclides#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/nuclides/1/edit").to route_to("nuclides#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/nuclides").to route_to("nuclides#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/nuclides/1").to route_to("nuclides#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/nuclides/1").to route_to("nuclides#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/nuclides/1").to route_to("nuclides#destroy", :id => "1")
    end

  end
end

require "rails_helper"

RSpec.describe AnalisiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/analisies").to route_to("analisies#index")
    end

    it "routes to #new" do
      expect(:get => "/analisies/new").to route_to("analisies#new")
    end

    it "routes to #show" do
      expect(:get => "/analisies/1").to route_to("analisies#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/analisies/1/edit").to route_to("analisies#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/analisies").to route_to("analisies#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/analisies/1").to route_to("analisies#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/analisies/1").to route_to("analisies#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/analisies/1").to route_to("analisies#destroy", :id => "1")
    end

  end
end

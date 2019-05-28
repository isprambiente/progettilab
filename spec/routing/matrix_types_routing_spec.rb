require "rails_helper"

RSpec.describe MatrixTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/matrix_types").to route_to("matrix_types#index")
    end

    it "routes to #new" do
      expect(:get => "/matrix_types/new").to route_to("matrix_types#new")
    end

    it "routes to #show" do
      expect(:get => "/matrix_types/1").to route_to("matrix_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/matrix_types/1/edit").to route_to("matrix_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/matrix_types").to route_to("matrix_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/matrix_types/1").to route_to("matrix_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/matrix_types/1").to route_to("matrix_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/matrix_types/1").to route_to("matrix_types#destroy", :id => "1")
    end

  end
end

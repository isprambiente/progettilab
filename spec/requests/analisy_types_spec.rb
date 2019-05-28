require 'rails_helper'

RSpec.describe "AnalisyTypes", type: :request do
  describe "GET /analisy_types" do
    it "works! (now write some real specs)" do
      get analisy_types_path
      expect(response).to have_http_status(200)
    end
  end
end

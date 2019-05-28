require 'rails_helper'

RSpec.describe "Nuclides", type: :request do
  describe "GET /nuclides" do
    it "works! (now write some real specs)" do
      get nuclides_path
      expect(response).to have_http_status(200)
    end
  end
end

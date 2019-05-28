require 'rails_helper'

RSpec.describe "Analisies", type: :request do
  describe "GET /analisies" do
    it "works! (now write some real specs)" do
      get analisies_path
      expect(response).to have_http_status(200)
    end
  end
end

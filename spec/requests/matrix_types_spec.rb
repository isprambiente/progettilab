require 'rails_helper'

RSpec.describe "MatrixTypes", type: :request do
  describe "GET /matrix_types" do
    it "works! (now write some real specs)" do
      get matrix_types_path
      expect(response).to have_http_status(200)
    end
  end
end

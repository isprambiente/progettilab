require 'rails_helper'

RSpec.describe "nuclides/show", type: :view do
  before(:each) do
    @nuclide = assign(:nuclide, Nuclide.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

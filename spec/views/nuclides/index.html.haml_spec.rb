require 'rails_helper'

RSpec.describe "nuclides/index", type: :view do
  before(:each) do
    assign(:nuclides, [
      Nuclide.create!(),
      Nuclide.create!()
    ])
  end

  it "renders a list of nuclides" do
    render
  end
end

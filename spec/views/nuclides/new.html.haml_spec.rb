require 'rails_helper'

RSpec.describe "nuclides/new", type: :view do
  before(:each) do
    assign(:nuclide, Nuclide.new())
  end

  it "renders new nuclide form" do
    render

    assert_select "form[action=?][method=?]", nuclides_path, "post" do
    end
  end
end

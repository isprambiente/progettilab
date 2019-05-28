require 'rails_helper'

RSpec.describe "nuclides/edit", type: :view do
  before(:each) do
    @nuclide = assign(:nuclide, Nuclide.create!())
  end

  it "renders the edit nuclide form" do
    render

    assert_select "form[action=?][method=?]", nuclide_path(@nuclide), "post" do
    end
  end
end

require 'rails_helper'

RSpec.describe "analisy_types/new", type: :view do
  before(:each) do
    assign(:analisy_type, AnalisyType.new())
  end

  it "renders new analisy_type form" do
    render

    assert_select "form[action=?][method=?]", analisy_types_path, "post" do
    end
  end
end

require 'rails_helper'

RSpec.describe "analisies/new", type: :view do
  before(:each) do
    assign(:analisy, Analisy.new())
  end

  it "renders new analisy form" do
    render

    assert_select "form[action=?][method=?]", analisies_path, "post" do
    end
  end
end

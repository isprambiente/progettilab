require 'rails_helper'

RSpec.describe "analisies/edit", type: :view do
  before(:each) do
    @analisy = assign(:analisy, Analisy.create!())
  end

  it "renders the edit analisy form" do
    render

    assert_select "form[action=?][method=?]", analisy_path(@analisy), "post" do
    end
  end
end

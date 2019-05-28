require 'rails_helper'

RSpec.describe "analisy_types/edit", type: :view do
  before(:each) do
    @analisy_type = assign(:analisy_type, AnalisyType.create!())
  end

  it "renders the edit analisy_type form" do
    render

    assert_select "form[action=?][method=?]", analisy_type_path(@analisy_type), "post" do
    end
  end
end

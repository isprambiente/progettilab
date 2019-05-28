require 'rails_helper'

RSpec.describe "units/new", type: :view do
  before(:each) do
    assign(:unit, Unit.new(
      :label => "MyString",
      :html => "MyString",
      :body => "MyText",
      :status => false
    ))
  end

  it "renders new unit form" do
    render

    assert_select "form[action=?][method=?]", units_path, "post" do

      assert_select "input#unit_label[name=?]", "unit[label]"

      assert_select "input#unit_html[name=?]", "unit[html]"

      assert_select "textarea#unit_body[name=?]", "unit[body]"

      assert_select "input#unit_status[name=?]", "unit[status]"
    end
  end
end

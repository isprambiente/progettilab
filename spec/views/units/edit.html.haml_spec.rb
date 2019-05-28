require 'rails_helper'

RSpec.describe "units/edit", type: :view do
  before(:each) do
    @unit = assign(:unit, Unit.create!(
      :label => "MyString",
      :html => "MyString",
      :body => "MyText",
      :status => false
    ))
  end

  it "renders the edit unit form" do
    render

    assert_select "form[action=?][method=?]", unit_path(@unit), "post" do

      assert_select "input#unit_label[name=?]", "unit[label]"

      assert_select "input#unit_html[name=?]", "unit[html]"

      assert_select "textarea#unit_body[name=?]", "unit[body]"

      assert_select "input#unit_status[name=?]", "unit[status]"
    end
  end
end

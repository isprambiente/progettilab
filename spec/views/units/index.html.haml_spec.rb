require 'rails_helper'

RSpec.describe "units/index", type: :view do
  before(:each) do
    assign(:units, [
      Unit.create!(
        :label => "Label",
        :html => "Html",
        :body => "MyText",
        :status => false
      ),
      Unit.create!(
        :label => "Label",
        :html => "Html",
        :body => "MyText",
        :status => false
      )
    ])
  end

  it "renders a list of units" do
    render
    assert_select "tr>td", :text => "Label".to_s, :count => 2
    assert_select "tr>td", :text => "Html".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end

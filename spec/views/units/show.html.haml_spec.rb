require 'rails_helper'

RSpec.describe "units/show", type: :view do
  before(:each) do
    @unit = assign(:unit, Unit.create!(
      :label => "Label",
      :html => "Html",
      :body => "MyText",
      :status => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Label/)
    expect(rendered).to match(/Html/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end

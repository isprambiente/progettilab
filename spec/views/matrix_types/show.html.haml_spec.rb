require 'rails_helper'

RSpec.describe "matrix_types/show", type: :view do
  before(:each) do
    @matrix_type = assign(:matrix_type, MatrixType.create!(
      :pid => 2,
      :title => "",
      :label => "",
      :body => "MyText",
      :radia => 3,
      :status => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
  end
end

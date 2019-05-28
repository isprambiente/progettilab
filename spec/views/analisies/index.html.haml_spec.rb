require 'rails_helper'

RSpec.describe "analisies/index", type: :view do
  before(:each) do
    assign(:analisies, [
      Analisy.create!(),
      Analisy.create!()
    ])
  end

  it "renders a list of analisies" do
    render
  end
end

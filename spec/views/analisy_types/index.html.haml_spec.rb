require 'rails_helper'

RSpec.describe "analisy_types/index", type: :view do
  before(:each) do
    assign(:analisy_types, [
      AnalisyType.create!(),
      AnalisyType.create!()
    ])
  end

  it "renders a list of analisy_types" do
    render
  end
end

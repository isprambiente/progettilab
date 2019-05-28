require 'rails_helper'

RSpec.describe "analisy_types/show", type: :view do
  before(:each) do
    @analisy_type = assign(:analisy_type, AnalisyType.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

require 'rails_helper'

RSpec.describe "analisies/show", type: :view do
  before(:each) do
    @analisy = assign(:analisy, Analisy.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

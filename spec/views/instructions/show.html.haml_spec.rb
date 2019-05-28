require 'rails_helper'

RSpec.describe "instructions/show", type: :view do
  before(:each) do
    @instruction = assign(:instruction, Instruction.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

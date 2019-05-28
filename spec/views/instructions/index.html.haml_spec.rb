require 'rails_helper'

RSpec.describe "instructions/index", type: :view do
  before(:each) do
    assign(:instructions, [
      Instruction.create!(),
      Instruction.create!()
    ])
  end

  it "renders a list of instructions" do
    render
  end
end

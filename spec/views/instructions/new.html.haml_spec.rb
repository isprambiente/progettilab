require 'rails_helper'

RSpec.describe "instructions/new", type: :view do
  before(:each) do
    assign(:instruction, Instruction.new())
  end

  it "renders new instruction form" do
    render

    assert_select "form[action=?][method=?]", instructions_path, "post" do
    end
  end
end

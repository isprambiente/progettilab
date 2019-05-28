require 'rails_helper'

RSpec.describe "logs/new", :type => :view do
  before(:each) do
    assign(:log, Log.new(
      :index => "MyString"
    ))
  end

  it "renders new log form" do
    render

    assert_select "form[action=?][method=?]", logs_path, "post" do

      assert_select "input#log_index[name=?]", "log[index]"
    end
  end
end

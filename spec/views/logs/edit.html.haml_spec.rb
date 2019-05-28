require 'rails_helper'

RSpec.describe "logs/edit", :type => :view do
  before(:each) do
    @log = assign(:log, Log.create!(
      :index => "MyString"
    ))
  end

  it "renders the edit log form" do
    render

    assert_select "form[action=?][method=?]", log_path(@log), "post" do

      assert_select "input#log_index[name=?]", "log[index]"
    end
  end
end

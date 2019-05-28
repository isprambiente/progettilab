require 'rails_helper'

RSpec.describe "logs/index", :type => :view do
  before(:each) do
    assign(:logs, [
      Log.create!(
        :index => "Index"
      ),
      Log.create!(
        :index => "Index"
      )
    ])
  end

  it "renders a list of logs" do
    render
    assert_select "tr>td", :text => "Index".to_s, :count => 2
  end
end

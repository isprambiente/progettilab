require 'rails_helper'

RSpec.describe "logs/show", :type => :view do
  before(:each) do
    @log = assign(:log, Log.create!(
      :index => "Index"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Index/)
  end
end

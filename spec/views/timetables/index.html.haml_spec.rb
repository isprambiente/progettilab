require 'rails_helper'

RSpec.describe "timetables/index", :type => :view do
  before(:each) do
    assign(:timetables, [
      Timetable.create!(),
      Timetable.create!()
    ])
  end

  it "renders a list of timetables" do
    render
  end
end

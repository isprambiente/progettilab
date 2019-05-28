require 'rails_helper'

RSpec.describe "timetables/show", :type => :view do
  before(:each) do
    @timetable = assign(:timetable, Timetable.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end

require 'rails_helper'

RSpec.describe "timetables/new", :type => :view do
  before(:each) do
    assign(:timetable, Timetable.new())
  end

  it "renders new timetable form" do
    render

    assert_select "form[action=?][method=?]", timetables_path, "post" do
    end
  end
end

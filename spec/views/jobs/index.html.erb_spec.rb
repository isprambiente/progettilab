require 'rails_helper'

RSpec.describe "jobs/index", :type => :view do
  before(:each) do
    assign(:jobs, [
      Job.create!(
        :code => "Code",
        :title => "Title",
        :revision => 1,
        :body => "MyText",
        :job_type => 2,
        :pa_support => false,
        :n_samples => 3,
        :metadata => "",
        :status => false
      ),
      Job.create!(
        :code => "Code",
        :title => "Title",
        :revision => 1,
        :body => "MyText",
        :job_type => 2,
        :pa_support => false,
        :n_samples => 3,
        :metadata => "",
        :status => false
      )
    ])
  end

  it "renders a list of jobs" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end

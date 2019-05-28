require 'rails_helper'

RSpec.describe "jobs/new", :type => :view do
  before(:each) do
    assign(:job, Job.new(
      :code => "MyString",
      :title => "MyString",
      :revision => 1,
      :body => "MyText",
      :job_type => 1,
      :pa_support => false,
      :n_samples => 1,
      :metadata => "",
      :status => false
    ))
  end

  it "renders new job form" do
    render

    assert_select "form[action=?][method=?]", jobs_path, "post" do

      assert_select "input#job_code[name=?]", "job[code]"

      assert_select "input#job_title[name=?]", "job[title]"

      assert_select "input#job_revision[name=?]", "job[revision]"

      assert_select "textarea#job_body[name=?]", "job[body]"

      assert_select "input#job_job_type[name=?]", "job[job_type]"

      assert_select "input#job_pa_support[name=?]", "job[pa_support]"

      assert_select "input#job_n_samples[name=?]", "job[n_samples]"

      assert_select "input#job_metadata[name=?]", "job[metadata]"

      assert_select "input#job_status[name=?]", "job[status]"
    end
  end
end

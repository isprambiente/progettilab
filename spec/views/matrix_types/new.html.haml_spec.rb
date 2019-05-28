require 'rails_helper'

RSpec.describe "matrix_types/new", type: :view do
  before(:each) do
    assign(:matrix_type, MatrixType.new(
      :pid => 1,
      :title => "",
      :label => "",
      :body => "MyText",
      :radia => 1,
      :status => false
    ))
  end

  it "renders new matrix_type form" do
    render

    assert_select "form[action=?][method=?]", matrix_types_path, "post" do

      assert_select "input#matrix_type_pid[name=?]", "matrix_type[pid]"

      assert_select "input#matrix_type_title[name=?]", "matrix_type[title]"

      assert_select "input#matrix_type_label[name=?]", "matrix_type[label]"

      assert_select "textarea#matrix_type_body[name=?]", "matrix_type[body]"

      assert_select "input#matrix_type_radia[name=?]", "matrix_type[radia]"

      assert_select "input#matrix_type_status[name=?]", "matrix_type[status]"
    end
  end
end

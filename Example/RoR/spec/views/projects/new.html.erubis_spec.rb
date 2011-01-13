require 'spec_helper'

describe "projects/new.html.erubis" do
  before(:each) do
    assign(:project, stub_model(Project,
      :name => "MyString",
      :published_by => 1,
      :worker => nil
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path, :method => "comment" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_published_by", :name => "project[published_by]"
      assert_select "input#project_worker", :name => "project[worker]"
    end
  end
end

require 'spec_helper'

describe "projects/edit.html.erubis" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "MyString",
      :published_by => 1,
      :worker => nil
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => project_path(@project), :method => "comment" do
      assert_select "input#project_name", :name => "project[name]"
      assert_select "input#project_published_by", :name => "project[published_by]"
      assert_select "input#project_worker", :name => "project[worker]"
    end
  end
end

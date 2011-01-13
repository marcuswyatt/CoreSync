require 'spec_helper'

describe "milestones/new.html.erubis" do
  before(:each) do
    assign(:milestone, stub_model(Milestone,
      :title => "MyString",
      :sequence_order => 1,
      :project => nil
    ).as_new_record)
  end

  it "renders new milestone form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => milestones_path, :method => "comment" do
      assert_select "input#milestone_title", :name => "milestone[title]"
      assert_select "input#milestone_sequence_order", :name => "milestone[sequence_order]"
      assert_select "input#milestone_project", :name => "milestone[project]"
    end
  end
end

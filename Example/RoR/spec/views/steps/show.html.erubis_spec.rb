require 'spec_helper'

describe "milestones/show.html.erubis" do
  before(:each) do
    @milestone = assign(:milestone, stub_model(Milestone,
      :title => "Milestone Type",
      :sequence_order => 1,
      :project => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Milestone Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end

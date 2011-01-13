require 'spec_helper'

describe "milestones/index.html.erubis" do
  before(:each) do
    assign(:milestones, [
      stub_model(Milestone,
        :title => "Milestone Type",
        :sequence_order => 1,
        :project => nil
      ),
      stub_model(Milestone,
        :title => "Milestone Type",
        :sequence_order => 1,
        :project => nil
      )
    ])
  end

  it "renders a list of milestones" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Milestone Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

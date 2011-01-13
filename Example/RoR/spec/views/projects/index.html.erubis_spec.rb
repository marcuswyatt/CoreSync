require 'spec_helper'

describe "projects/index.html.erubis" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :name => "Name",
        :published_by => 1,
        :worker => nil
      ),
      stub_model(Project,
        :name => "Name",
        :published_by => 1,
        :worker => nil
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end

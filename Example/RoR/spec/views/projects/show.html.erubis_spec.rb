require 'spec_helper'

describe "projects/show.html.erubis" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :name => "Name",
      :published_by => 1,
      :worker => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end

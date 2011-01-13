require 'spec_helper'

describe "workers/show.html.erubis" do
  before(:each) do
    @worker = assign(:worker, stub_model(Worker,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end

require 'spec_helper'

describe "workers/index.html.erubis" do
  before(:each) do
    assign(:workers, [
      stub_model(Worker,
        :name => "Name"
      ),
      stub_model(Worker,
        :name => "Name"
      )
    ])
  end

  it "renders a list of workers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end

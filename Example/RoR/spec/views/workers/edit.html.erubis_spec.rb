require 'spec_helper'

describe "workers/edit.html.erubis" do
  before(:each) do
    @worker = assign(:worker, stub_model(Worker,
      :name => "MyString"
    ))
  end

  it "renders the edit worker form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => worker_path(@worker), :method => "comment" do
      assert_select "input#worker_name", :name => "worker[name]"
    end
  end
end

require 'spec_helper'

describe "workers/new.html.erubis" do
  before(:each) do
    assign(:worker, stub_model(Worker,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new worker form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => workers_path, :method => "comment" do
      assert_select "input#worker_name", :name => "worker[name]"
    end
  end
end

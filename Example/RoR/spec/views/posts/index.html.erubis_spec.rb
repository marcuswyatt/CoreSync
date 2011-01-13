require 'spec_helper'

describe "comments/index.html.erubis" do
  before(:each) do
    assign(:comments, [
      stub_model(Comment,
        :title => "Title",
        :body => "MyText",
        :read_count => 1,
        :lat => 1.5,
        :lng => "9.99",
        :photo => "",
        :published => false
      ),
      stub_model(Comment,
        :title => "Title",
        :body => "MyText",
        :read_count => 1,
        :lat => 1.5,
        :lng => "9.99",
        :photo => "",
        :published => false
      )
    ])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end

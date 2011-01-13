require 'spec_helper'

describe "comments/new.html.erubis" do
  before(:each) do
    assign(:comment, stub_model(Comment,
      :title => "MyString",
      :body => "MyText",
      :read_count => 1,
      :lat => 1.5,
      :lng => "9.99",
      :photo => "",
      :published => false
    ).as_new_record)
  end

  it "renders new comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path, :method => "comment" do
      assert_select "input#comment_title", :name => "comment[title]"
      assert_select "textarea#comment_body", :name => "comment[body]"
      assert_select "input#comment_read_count", :name => "comment[read_count]"
      assert_select "input#comment_lat", :name => "comment[lat]"
      assert_select "input#comment_lng", :name => "comment[lng]"
      assert_select "input#comment_photo", :name => "comment[photo]"
      assert_select "input#comment_published", :name => "comment[published]"
    end
  end
end

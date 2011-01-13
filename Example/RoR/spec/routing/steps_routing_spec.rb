require "spec_helper"

describe MilestonesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/milestones" }.should route_to(:controller => "milestones", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/milestones/new" }.should route_to(:controller => "milestones", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/milestones/1" }.should route_to(:controller => "milestones", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/milestones/1/edit" }.should route_to(:controller => "milestones", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :comment => "/milestones" }.should route_to(:controller => "milestones", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/milestones/1" }.should route_to(:controller => "milestones", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/milestones/1" }.should route_to(:controller => "milestones", :action => "destroy", :id => "1")
    end

  end
end

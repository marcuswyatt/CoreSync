require "spec_helper"

describe WorkersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/workers" }.should route_to(:controller => "workers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/workers/new" }.should route_to(:controller => "workers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/workers/1" }.should route_to(:controller => "workers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/workers/1/edit" }.should route_to(:controller => "workers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :comment => "/workers" }.should route_to(:controller => "workers", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/workers/1" }.should route_to(:controller => "workers", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/workers/1" }.should route_to(:controller => "workers", :action => "destroy", :id => "1")
    end

  end
end

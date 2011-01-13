class MilestonesController < ApplicationController
  
  respond_to :html, :xml, :json
  
  before_filter :find_project, :only => [:index, :new, :create]
  
  # GET /projects/:project_id/milestones
  # GET /projects/:project_id/milestones.xml
  # GET /projects/:project_id/milestones.json
  def index
    @milestones = @project.milestones.all

    respond_with(@project, @milestones)
  end

  # GET /milestones/1
  # GET /milestones/1.xml
  # GET /milestones/1.json
  def show
    @milestone = Milestone.find(params[:id])

    respond_with @milestones
  end

  # GET /projects/:project_id/milestones/new
  # GET /projects/:project_id/milestones/new.xml
  # GET /projects/:project_id/milestones/new.json
  def new
    @milestone = @project.milestones.new
    @milestone.sequence_order = @project.milestones.size
    respond_with(@project, @milestones)
  end

  # GET /milestones/1/edit
  def edit
    @milestone = Milestone.find(params[:id])
  end

  # POST /projects/:project_id/milestones
  # POST /projects/:project_id/milestones.xml
  # POST /projects/:project_id/milestones.json
  def create
    @milestone = @project.milestones.new(params[:milestone])

    flash[:notice] = 'Milestone was successfully created.' if @milestone.save
    respond_with(@project, @milestones)
  end

  # PUT /milestones/1
  # PUT /milestones/1.xml
  # PUT /milestones/1.json
  def update
    @milestone = Milestone.find(params[:id])

    flash[:notice] = 'Milestone was successfully updated.' if @milestone.update_attributes(params[:milestone])
    respond_with @milestones
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.xml
  # DELETE /milestones/1.json
  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    respond_with @milestones
  end
  
  private 
  
    def find_project
      @project = Project.find(params[:project_id])
    end
end
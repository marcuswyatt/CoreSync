class ProjectsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  # GET /projects
  # GET /projects.xml
  # GET /projects.json
  def index
    @projects = Project.all

    respond_with(@projects) do |format|
      format.xml { render :xml => @projects.to_xml(:include => :milestones) }
      format.json { render :json => @projects.to_json(:include => :milestones) }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

    respond_with(@project) do |format|
      format.xml { render :xml => @project.to_xml(:include => :milestones) }
      format.json { render :json => @project.to_json(:include => :milestones) }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_with @project
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    flash[:notice] = 'Project was successfully created.' if @project.save
    respond_with(@project) do |format|
      format.xml { render :xml => @project.to_xml(:include => :milestones) }
      format.json { render :json => @project.to_json(:include => :milestones) }
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    flash[:notice] = 'Project was successfully updated.' if @project.update_attributes(params[:project])
    
    respond_with @project
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_with @project
  end
end
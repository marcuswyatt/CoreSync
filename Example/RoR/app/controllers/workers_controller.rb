class WorkersController < ApplicationController
  
  respond_to :html, :xml, :json
  
  # GET /workers
  # GET /workers.xml
  # GET /workers.json
  def index
    @workers = Worker.all

    respond_with @workers
  end

  # GET /workers/1
  # GET /workers/1.xml
  # GET /workers/1.json
  def show
    @worker = Worker.find(params[:id])

    respond_with @worker
  end

  # GET /workers/new
  # GET /workers/new.xml
  # GET /workers/new.json
  def new
    @worker = Worker.new

    respond_with @worker
  end

  # GET /workers/1/edit
  def edit
    @worker = Worker.find(params[:id])
  end

  # POST /workers
  # POST /workers.xml
  # POST /workers.json
  def create
    @worker = Worker.new(params[:worker])

    flash[:notice] = 'Worker was successfully created.' if @worker.save
    respond_with @worker
  end

  # PUT /workers/1
  # PUT /workers/1.xml
  # PUT /workers/1.json
  def update
    @worker = Worker.find(params[:id])

    flash[:notice] = 'Worker was successfully updated.' if @worker.update_attributes(params[:worker])
    respond_with @worker
  end

  # DELETE /workers/1
  # DELETE /workers/1.xml
  # DELETE /workers/1.json
  def destroy
    @worker = Worker.find(params[:id])
    @worker.destroy

    respond_with @worker
  end
end
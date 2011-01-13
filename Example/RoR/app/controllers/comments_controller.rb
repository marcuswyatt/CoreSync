class CommentsController < ApplicationController
  
  respond_to :html, :xml, :json
  
  before_filter :find_worker
  
  # GET /workers/:worker_id/comments
  # GET /workers/:worker_id/comments.xml
  # GET /workers/:worker_id/comments.json
  def index
    @comments = @worker.comments.all

    respond_with(@worker, @comments)
  end

  # GET /workers/:worker_id/comments/1
  # GET /workers/:worker_id/comments/1.xml
  # GET /workers/:worker_id/comments/1.json
  def show
    @comment = @worker.comments.find(params[:id])

    respond_with(@worker, @comments)
  end

  # GET /workers/:worker_id/comments/new
  # GET /workers/:worker_id/comments/new.xml
  # GET /workers/:worker_id/comments/new.json
  def new
    @comment = @worker.comments.new

    respond_with(@worker, @comments)
  end

  # GET /workers/:worker_id/comments/1/edit
  def edit
    @comment = @worker.comments.find(params[:id])
  end

  # POST /workers/:worker_id/comments
  # POST /workers/:worker_id/comments.xml
  # POST /workers/:worker_id/comments.json
  def create
    @comment = @worker.comments.new(params[:comment])

    flash[:notice] = 'Comment was successfully created.' if @comment.save
    respond_with(@worker, @comments)
  end

  # PUT /workers/:worker_id/comments/1
  # PUT /workers/:worker_id/comments/1.xml
  # PUT /workers/:worker_id/comments/1.json
  def update
    @comment = @worker.comments.find(params[:id])

    flash[:notice] = 'Comment was successfully updated.' if @comment.update_attributes(params[:comment])
    respond_with(@worker, @comments)
  end

  # DELETE /workers/:worker_id/comments/1
  # DELETE /workers/:worker_id/comments/1.xml
  # DELETE /workers/:worker_id/comments/1.json
  def destroy
    @comment = @worker.comments.find(params[:id])
    @comment.destroy

    respond_with(@worker, @comments)
  end
  
  private 
  
    def find_worker
      @worker = Worker.find(params[:worker_id])
    end
  
end
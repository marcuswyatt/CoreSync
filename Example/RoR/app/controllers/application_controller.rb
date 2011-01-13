class ApplicationController < ActionController::Base
  protect_from_forgery
  
  skip_before_filter :verify_authenticity_token do |controller|
    controller.request.format == :json || controller.request.format == :xml
  end
  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    respond_to do |format|
      format.html { render :action => (exception.record.new_record? ? :new : :edit) }
      format.xml { render :xml => exception.message, :status => 404 }
      format.json { render :json => exception.message, :status => 404 }
    end
    
  end
      
end

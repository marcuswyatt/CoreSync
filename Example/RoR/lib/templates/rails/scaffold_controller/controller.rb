class <%= controller_class_name %>Controller < ApplicationController
  
  respond_to :html, :xml, :json
  
<% unless options[:singleton] -%>
  # GET <%= route_url %>
  # GET <%= route_url %>.xml
  # GET <%= route_url %>.json
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>

    respond_with @<%= table_name %>
  end
<% end -%>

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.xml
  # GET <%= route_url %>/1.json
  def show
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    respond_with @<%= file_name %>
  end

  # GET <%= route_url %>/new
  # GET <%= route_url %>/new.xml
  # GET <%= route_url %>/new.json
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>

    respond_with @<%= file_name %>
  end

  # GET <%= route_url %>/1/edit
  def edit
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.xml
  # POST <%= route_url %>.json
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

    flash[:notice] = '<%= human_name %> was successfully created.' if @<%= orm_instance.save %>
    respond_with @<%= file_name %>
  end

  # PUT <%= route_url %>/1
  # PUT <%= route_url %>/1.xml
  # PUT <%= route_url %>/1.json
  def update
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

    flash[:notice] = '<%= human_name %> was successfully updated.' if @<%= orm_instance.update_attributes("params[:#{file_name}]") %>
    respond_with @<%= file_name %>
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.xml
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    @<%= orm_instance.destroy %>

    respond_with @<%= file_name %>
  end
end
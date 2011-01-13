class Comment < ActiveRecord::Base
  
  belongs_to :worker
  belongs_to :project, :touch => true
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
end

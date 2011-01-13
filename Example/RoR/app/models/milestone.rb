class Milestone < ActiveRecord::Base
  
  belongs_to :project, :touch => true
  
  validates_presence_of :title, :message => "can't be blank"
end

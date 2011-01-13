class Worker < ActiveRecord::Base
  
  has_many :projects
  has_many :comments, :order => 'comments.title ASC'
   
  validates_presence_of :name

end

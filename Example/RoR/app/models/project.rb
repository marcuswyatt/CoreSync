class Project < ActiveRecord::Base
  
  belongs_to :worker, :validate => true
  has_many :milestones, :validate => true, :dependent => :destroy, :order => 'milestones.sequence_order ASC'
  has_many :comments, :validate => true, :dependent => :destroy, :order => 'milestones.sequence_order ASC'
  
  accepts_nested_attributes_for :milestones,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes['title'].blank? }

    accepts_nested_attributes_for :milestones,
      :allow_destroy => true,
      :reject_if => proc { |attributes| attributes['title'].blank? }
    
  validates_presence_of :name
  validates_associated :milestones, :on => [:insert, :update]
  validates_associated :comments, :on => [:insert, :update]
  validates_presence_of :planned_duration, :on => :create, :message => "is a required field."
  
end

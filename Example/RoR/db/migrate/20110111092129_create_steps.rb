class CreateMilestones < ActiveRecord::Migration
  def self.up
    create_table :milestones do |t|
      t.string :title
      t.datetime :completed_at
      t.integer :sequence_order
      t.datetime :deleted_at
      
      t.references :project

      t.timestamps
    end
  end

  def self.down
    drop_table :milestones
  end
end



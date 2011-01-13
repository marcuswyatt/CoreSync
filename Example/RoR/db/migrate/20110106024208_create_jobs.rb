class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string   :name
      t.datetime :planned_start_at
      t.integer  :published_by
      t.boolean  :is_prototype,                           :default => false
      t.string   :state,                                  :default => "unallocated"
      t.datetime :deleted_at
      t.string   :batch_id
      t.integer  :planned_duration
      t.datetime :actual_start_at
      t.datetime :actual_end_at
      t.datetime :published_at
      t.string   :progress_state,                         :default => "not_started"
      t.string   :third_party_id,                         :default => ""
      t.string   :zone,                      :limit => 2
      t.datetime :requested_at
      t.datetime :alarm_at
      
      t.references  :worker

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end

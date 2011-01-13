class CreateWorkers < ActiveRecord::Migration
  def self.up
    create_table :workers do |t|
      t.string   :name
      t.integer  :account_id
      t.datetime :deleted_at
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :head_telemetry_id
      t.decimal  :lat
      t.decimal  :lng
      t.datetime :effective_at
      t.decimal  :speed
      t.decimal  :heading
      t.string   :third_party_id,    :default => ""
      
      t.timestamps
    end
  end

  def self.down
    drop_table :workers
  end
end

class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table   :projects do |t|
      t.string     :name
      t.integer    :created_by
      t.references :account      
      t.timestamps
      t.datetime   :suspend_at
      t.datetime   :delete_at
    end
    add_index :projects, :account_id    
  end

  def self.down
    drop_table :projects
  end
end

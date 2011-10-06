class CreateMemberships < ActiveRecord::Migration
  def self.up
    create_table :memberships do |t|
      t.integer :user_id
      t.integer  :project_id
      t.integer  :created_by
      t.boolean  :admin, :default => false
      t.timestamps
      t.datetime :enroll_at
      t.datetime :suspend_at
      t.datetime :delete_at
    end
    add_index :memberships, :user_id
    add_index :memberships, :project_id
  end

  def self.down
    drop_table :memberships
  end
end
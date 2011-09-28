class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string   :name
      t.string   :email
      t.boolean  :admin, :default => false
      t.timestamps
      t.datetime :suspend_at
      t.datetime :delete_at
    end
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :email
    drop_table :users
  end
end

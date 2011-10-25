class AddStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string
    remove_column :users, :admin
    remove_column :users, :suspend_at
    remove_column :users, :delete_at
  end

  def self.down
    remove_column :users, :state
    add_column :users, :admin, :boolean
    add_column :users, :suspend_at, :datetime
    add_column :users, :delete_at, :datetime
  end
end

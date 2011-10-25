class AddStateToProject < ActiveRecord::Migration
  def self.up
    add_column    :projects, :state, :string
    remove_column :projects, :suspend_at
    remove_column :projects, :delete_at
  end

  def self.down
    remove_column :projects, :state
    add_column    :projects, :suspend_at, :datetime
    add_column    :projects, :delete_at, :datetime
  end
end

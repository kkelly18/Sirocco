class AddStateToAccount < ActiveRecord::Migration
  def self.up
    add_column    :accounts, :state, :string
    remove_column :accounts, :suspend_at
    remove_column :accounts, :delete_at
  end

  def self.down
    remove_column :accounts, :state
    add_column    :accounts, :suspend_at, :datetime
    add_column    :accounts, :delete_at, :datetime
  end
end

class AddStateToMemberships < ActiveRecord::Migration
  def self.up
    add_column    :memberships, :state, :string
    add_column    :memberships, :access_state, :string
    remove_column :memberships, :admin
    remove_column :memberships, :enroll_at
    remove_column :memberships, :suspend_at
    remove_column :memberships, :delete_at
  end

  def self.down
    remove_column :memberships, :state
    remove_column :memberships, :access_state
    add_column    :memberships, :admin, :boolean
    add_column    :memberships, :enroll_at, :datatime
    add_column    :memberships, :suspend_at, :datetime
    add_column    :memberships, :delete_at, :datetime
  end
end

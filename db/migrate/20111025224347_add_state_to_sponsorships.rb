class AddStateToSponsorships < ActiveRecord::Migration
  def self.up
    add_column    :sponsorships, :state, :string
    add_column    :sponsorships, :access_state, :string
    remove_column :sponsorships, :admin
    remove_column :sponsorships, :enroll_at
    remove_column :sponsorships, :suspend_at
    remove_column :sponsorships, :delete_at
  end

  def self.down
    remove_column :sponsorships, :state
    remove_column :sponsorships, :access_state
    add_column    :sponsorships, :admin, :boolean
    add_column    :sponsorships, :enroll_at, :datatime
    add_column    :sponsorships, :suspend_at, :datetime
    add_column    :sponsorships, :delete_at, :datetime
  end

end

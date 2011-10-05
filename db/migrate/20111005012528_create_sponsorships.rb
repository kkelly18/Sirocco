class CreateSponsorships < ActiveRecord::Migration
  def self.up
    create_table :sponsorships do |t|
      t.integer :user_id
      t.integer :account_id
      t.integer :created_by
      t.boolean :admin, :default => false
      t.timestamps
      t.datetime :enroll_at
      t.datetime :suspend_at
      t.datetime :delete_at
    end
    add_index :sponsorships, :user_id
    add_index :sponsorships, :account_id
  end

  def self.down
    drop_table :sponsorships
  end
end

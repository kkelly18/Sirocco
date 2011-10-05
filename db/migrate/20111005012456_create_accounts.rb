class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.integer :created_by
      t.timestamps
      t.datetime :suspend_at
      t.datetime :delete_at
    end
  end

  def self.down
    drop_table :accounts
  end
end

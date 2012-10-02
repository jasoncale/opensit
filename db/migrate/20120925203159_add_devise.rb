class AddDevise < ActiveRecord::Migration
  def self.up
    null    = false
    default = ""

    add_column :users, :encrypted_password, :string, :null => null, :default => default, :limit => 128
    add_column :users, :password_salt, :string
    add_column :users, :authentication_token, :string
    add_column :users, :confirmation_token,   :string
    add_column :users, :confirmed_at,         :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :reset_password_token, :string
    add_column :users, :remember_token,      :string
    add_column :users, :remember_created_at, :datetime
    add_column :users, :sign_in_count,      :integer, :default => 0
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at,    :datetime
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip,    :string

    #:lockable fields contributed by MattSlay
    add_column :users, :failed_attempts, :integer, :default => 0
    add_column :users, :unlock_token,   :string
    add_column :users, :locked_at, :datetime

  end

  def self.down
    remove_column :users, :encrypted_password
    remove_column :users, :password_salt
    remove_column :users, :authentication_token
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
    remove_column :users, :reset_password_token
    remove_column :users, :remember_token
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
    remove_column :users, :failed_attempts
    remove_column :users, :unlock_token
    remove_column :users, :locked_at
  end
end
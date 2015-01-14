class AddReceiveEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :receive_email, :boolean, default: true
  end
end

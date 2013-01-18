class CreateMessagesTable < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.string :subject
      t.text :body
      t.integer :from_user_id
      t.integer :to_user_id
      t.boolean :read, :default => false

      t.timestamps
    end
  end
end
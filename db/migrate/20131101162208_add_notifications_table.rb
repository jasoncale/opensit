class AddNotificationsTable < ActiveRecord::Migration
  def change
		create_table(:notifications) do |t|
	    t.integer :user_id
	    t.integer :notification_type
	    t.boolean :viewed
			t.string :meta
	  end

	  create_table(:notification_types) do |t|
	  	t.string :event
	  	t.string :text
	  end
  end
end

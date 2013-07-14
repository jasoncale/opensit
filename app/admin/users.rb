ActiveAdmin.register User do

	index do
		column :id
	  column :username
	  column :first_name
	  column :last_name
	  column :email
    default_actions
  end
  
end

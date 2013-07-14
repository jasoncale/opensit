ActiveAdmin.register Sit do

	index do
		column :id
	  column :title
	  column :body
	  column :created_at
    default_actions
  end
  
end

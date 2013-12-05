class AddSearchIndexesForTextacular < ActiveRecord::Migration
  execute "
    create index sit_title on sits using gin(to_tsvector('english', title));
    create index sit_body on sits using gin(to_tsvector('english', body));
    create index tag_name on tags using gin(to_tsvector('english', name));
    "
end

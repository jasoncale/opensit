class AddSearchIndexesForTextacular < ActiveRecord::Migration
  execute "
    create index on sits using gin(to_tsvector('english', title));
    create index on sits using gin(to_tsvector('english', body));
    create index on tags using gin(to_tsvector('english', name));
    "
end

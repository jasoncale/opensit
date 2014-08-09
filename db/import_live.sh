heroku pgbackups:capture --expire -a opensit
curl -o latest.dump `heroku pgbackups:url -a opensit`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d opensit_development latest.dump
rm latest.dump

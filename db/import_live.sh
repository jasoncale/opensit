heroku pgbackups:capture --expire -a opensit
curl -o latest.dump `heroku pgbackups:url -a opensit`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U opensit -d opensit_development latest.dump

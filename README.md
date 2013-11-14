OpenSit is a contemplative discussion platform, currently under development.

[![Code Climate](https://codeclimate.com/github/danbartlett/opensit.png)](https://codeclimate.com/github/danbartlett/opensit)

#Installation

To install locally for your own hacking pleasure:

* Clone the repo and `cd` into it.
* `bundle install`
* `cp config/database.yml.example config/database.yml`
* `bundle exec rake db:create db:migrate`
* `bundle exec guard`
* Go to `localhost:3000`

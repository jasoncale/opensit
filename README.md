OpenSit
=======

![OpenSit - Where Meditators Meet](http://opensit.com/images/logomark_readme.png)
[![Code Climate](https://codeclimate.com/github/danbartlett/opensit.png)](https://codeclimate.com/github/danbartlett/opensit)

OpenSit is an open source meditation community - a place to share your meditation practice and follow friends.

The community lives at [OpenSit.com](http://opensit.com)

#Installation

To install locally for your own hacking pleasure:

* Clone the repo and `cd` into it.
* `bundle install`
* `cp config/database.yml.example config/database.yml`
* `bundle exec rake db:create db:migrate`
* `bundle exec guard`
* Go to `localhost:3000`

rake db:test:prepare
rspec spec to run all the tests

#License

All the code behind OpenSit is made available for free under the GNU Affero General Public License V3. See LICENSE and COPYRIGHT for more details.
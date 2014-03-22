OpenSit
=======

<img src="http://opensit.com/images/logomark_readme.png" align="right" title="Where Meditators Meet">

OpenSit is an open source meditation community - a place where meditators can share and develop their practice. It lives at **[OpenSit.com](http://opensit.com)**.

[![Code Climate](https://codeclimate.com/github/danbartlett/opensit.png)](https://codeclimate.com/github/danbartlett/opensit)

#Getting Started

To install locally for your own hacking pleasure:

* Clone the repo and `cd` into it.
* `bundle install`
* `cp config/database.yml.example config/database.yml`
* `bundle exec rake db:create db:migrate`
* `bundle exec guard`
* Go to `localhost:3000`. Voila!
* To run the the tests: `rake db:test:prepare` and then `rspec spec`

#Contributing

Before getting busy, please [search our issues](https://github.com/danbartlett/opensit/issues) to see if the issue/feature you're addressing is already being discussed or worked on. If it isn't, you should consider creating an issue so that we can give you some feedback. When you're ready to get coding:

* Create a feature branch - `git checkout -b your-feature-or-fix`
* Commit early and often (you can clear it up later if you want to)
* Remember to `git rebase master` if master has been updated while you're working on your feature
* Push your feature branch and create a pull request
* Another developer will then review and give it the thumbs up or offer some comments.
* If you want push a work in progress, that's fine, but mark it as so e.g. "[WIP] New comments system"
* Once reviewed and ok'ed, your changes will be merged into master
* Remember to add tests!

If you find a security issue please don't create an issue - email hello@opensit.com with details so that we can do our best to minimise any potential problems.

#License

All the code behind OpenSit is made available for free under the GNU Affero General Public License V3. See [LICENSE](https://github.com/danbartlett/opensit/blob/master/LICENSE) and [COPYRIGHT](https://github.com/danbartlett/opensit/blob/master/COPYRIGHT) for more details.
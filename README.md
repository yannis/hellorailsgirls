# README

* Ruby version: 2.3.3

* Rails version: 5.1.2

* System dependencies:
  - redis server: 3.0.5
  - yarn: 0.24.6

* Load packages: `$ yarn`

* Database creation: `$ bundle exec rails db:create`

* Database initialization: `$ bundle exec rails db:create`

* How to run the test suite: `$ bundle exec rake`

* Precompile assets: `$ bundle exec rails assets:precompile`

* Deployment:
```
export RAILS_ENV=production
rvm use 2.3.3
nvm use 6
npm i -g yarn
yarn
bundle install
bundle exec rails db:migrate
bundle exec rails assets:precompile
bundle exec rails s
```

set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails db:seed

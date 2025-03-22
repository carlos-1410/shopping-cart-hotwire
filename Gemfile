# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.3"

gem "active_model_serializers"
gem "aws-sdk-s3", "~> 1.182", require: false
gem "bootsnap", require: false
gem "dotenv-rails"
gem "faker", "~> 3.5", ">= 3.5.1"
gem "font-awesome-rails"
gem "image_processing", ">= 1.2"
gem "json-schema", "~> 4.3"
gem "multi_json", "~> 1.15"
gem "pg", "~> 1.5"
gem "puma", "~> 6.6"
gem "rails", "8.0.2"
gem "rubocop", "~> 1.64"
gem "rubocop-rails", "~> 2.30"
gem "shakapacker", "= 8.2"
gem "solargraph", "~> 0.52.0"
gem "sprockets-rails"
gem "turbo-rails"

group :development, :test do
  gem "byebug", platform: :mri
  gem "dockerfile-rails", ">= 1.7"
  gem "factory_bot_rails", "~> 6.4.4"
  gem "minitest", ">= 5.22"
  gem "mocha", "~> 2.7"
  gem "rails-controller-testing", "~> 1.0"
  gem "webmock", "~> 3.23.0"
end

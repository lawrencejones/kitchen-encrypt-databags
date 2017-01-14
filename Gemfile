# frozen_string_literal: true
source "https://rubygems.org"

gemspec

gem "berkshelf"
gem "kitchen-docker"
gem "pry"
gem "rspec"
# We need this constraint so rubocop doesn't pick a version of rainbow that requires rake
# when running on CircleCI
# https://github.com/sickill/rainbow/issues/40
gem "rainbow", ">= 2.1.0", "< 2.2.0"
gem "rubocop"

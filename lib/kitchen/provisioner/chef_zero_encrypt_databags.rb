# frozen_string_literal: true

require "kitchen"
require "kitchen/provisioner/chef_zero"

require_relative "encrypt_databags"

module Kitchen
  module Provisioner
    class ChefZeroEncryptDatabags < ::Kitchen::Provisioner::ChefZero
      include EncryptDatabags
    end
  end
end

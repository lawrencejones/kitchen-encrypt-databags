# frozen_string_literal: true

require "kitchen"
require "kitchen/provisioner/dokken"

require_relative "encrypt_databags"

module Kitchen
  module Provisioner
    class DokkenEncryptDatabags < ::Kitchen::Provisioner::Dokken
      include EncryptDatabags
    end
  end
end

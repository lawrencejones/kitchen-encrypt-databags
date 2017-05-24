# frozen_string_literal: true

require "kitchen"
require "kitchen/provisioner/chef_zero"
require "chef/encrypted_data_bag_item"

module Kitchen
  module Provisioner
    # This class defines the method overrides for typical Chef provisioners so that the
    # data bags are encrypted on the way into the sandbox.
    module EncryptDatabags
      class DataBagEncryptionException < StandardError
      end

      def create_sandbox
        super # call the original, which will insert databags
        encrypt_data_bags
      end

      private

      # Take the data bags that we have copied to the box, and encrypt each with the
      # provided data bag secret key. This allows users to create unencrypted data bags
      # for their tests that they can then use via Chef::EncryptedDataBagItem.load
      #
      # This will only target data bags at sandbox/data_bags/**/*.json, and will need to
      # be run after the data bags have been copied into place.
      def encrypt_data_bags
        unless secret_key
          raise DataBagEncryptionException, <<-MSG
          Encrypting data bags requires an encrypted_data_bag_secret_key_path!
          MSG
        end

        data_bag_files.each do |data_bag_file|
          data_bag_enc = encrypt_data_bag(data_bag_file, secret_key)
          File.write(data_bag_file, JSON.pretty_generate(data_bag_enc))
        end
      end

      def data_bag_files
        data_bags_glob = File.join(sandbox_path, "data_bags", "**", "*.json")
        Dir.glob(data_bags_glob)
      end

      def encrypt_data_bag(data_bag_path, secret_key)
        data_bag = JSON.parse(File.read(data_bag_path))
        ::Chef::EncryptedDataBagItem.encrypt_data_bag_item(data_bag, secret_key)
      rescue StandardError => err
        raise DataBagEncryptionException, <<-MSG
        Failed to encrypt data bag at #{data_bag_path} with error "#{err}"
        MSG
      end

      def secret_key
        @secret_key ||= begin
          secret_key_path = config[:encrypted_data_bag_secret_key_path] || ""
          # The strip is important- this is how Chef reads the secret file, and we'll need
          # to do the same if Chef is to decrypt anything with this key
          File.read(secret_key_path).strip if File.exist?(secret_key_path)
        end
      end
    end
  end
end

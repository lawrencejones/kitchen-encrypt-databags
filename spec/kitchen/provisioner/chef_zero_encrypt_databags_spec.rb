# frozen_string_literal: true
require "kitchen/provisioner/chef_zero_encrypt_databags"

RSpec.describe(Kitchen::Provisioner::ChefZeroEncryptDatabags) do
  subject(:provisioner) do
    described_class.new(config).finalize_config!(instance)
  end

  after(:each) do
    FileUtils.remove_entry(config[:kitchen_root])
    provisioner.cleanup_sandbox
  end

  def sandbox_path(path)
    Pathname.new(provisioner.sandbox_path).join(path)
  end

  let(:instance) do
    double(
      name: "confidential-beans",
      logger: logger,
      suite: suite,
      platform: platform,
    )
  end

  let(:logger)         { Logger.new(logged_output) }
  let(:logged_output)  { StringIO.new }
  let(:suite)          { double(name: "suite") }
  let(:platform)       { double(os_type: nil) }

  describe "#create_sandbox" do
    let(:config) do
      {
        test_base_path: "/base",
        kitchen_root: Dir.mktmpdir,
        data_bags_path: fixture_path("data_bags"),
        encrypted_data_bag_secret_key_path: secret_key_path,
      }
    end

    let(:secret_key_path) { fixture_path("encrypted_data_bag_secret") }
    let(:sandbox_data_bag_path) { sandbox_path("data_bags/users/sudoers_enc.json") }
    let(:secret) { File.read(secret_key_path).strip }

    it "encrypts the data bags copied from :data_bags_path with secret" do
      provisioner.create_sandbox

      sandbox_data_bag = JSON.parse(File.read(sandbox_data_bag_path))
      edb = Chef::EncryptedDataBagItem.new(sandbox_data_bag, secret)

      # From sudoers fixture in spec/data_bags
      expect(edb["root"]).to eql("password" => "much-entropy")
    end

    context "when missing :encrypted_data_bag_secret_key_path" do
      before { config.delete(:encrypted_data_bag_secret_key_path) }

      it "raises DataBagEncryptionException with message" do
        expect { provisioner.create_sandbox }.
          to raise_exception(
            described_class::DataBagEncryptionException,
            /requires.+encrypted_data_bag_secret_key_path/i,
          )
      end
    end
  end
end

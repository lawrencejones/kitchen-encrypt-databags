# frozen_string_literal: true

# This recipe isn't meant to do anything sensible- just to test that password inside the
# sudoers_enc databag is accessible by decrypting the JSON with the secret key provisioned
# on the sandbox.

sudoers = Chef::EncryptedDataBagItem.load("users", "sudoers_enc")
file "/etc/root_password" do
  content sudoers["root"]["password"]
end

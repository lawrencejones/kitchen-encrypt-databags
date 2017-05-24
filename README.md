# kitchen-encrypt-databags ![kitchen-encrypt-databags Build Status](https://circleci.com/gh/lawrencejones/kitchen-encrypt-databags.png)

This gem extends the ChefZero and Dokken provisioners for
[test-kitchen](https://github.com/test-kitchen/test-kitchen) so that the data
bags provisioned in the target machine sandbox are encrypted during the
provisioning phase.

Just add `gem 'kitchen-encrypt-databags'` to your `Gemfile` and select either
the `chef_zero_encrypt_databags` or `dokken_encrypt_databags` provisioner in
your `.kitchen.yml` like so:

```yaml
---
driver:
  name: docker

provisioner:
  name: dokken_encrypt_databags
  data_bags_path: text/fixtures/data_bags
  encrypted_data_bag_secret_key_path: test/fixtures/encrypted_data_bag_secret
```

## Why do I want this?

When testing cookbooks, it's a common requirement to create data bag JSON
fixture files, which test-kitchen will push into the testing sandbox as part of
the provisioning process.

This is great, except for when you use encrypted data bags. Encrypting data bags
requires a `knife` invocation, and leaves the JSON fixtures in your repo looking
like:

```json
{
  "id": "aws_keys",
  "secret_access_key": {
    "encrypted_data": "Vmx68rgbRGYqQjbt1w8oPhucPDsUS24qKb+P3Y82f3AembTVnBKLfPRmpO2s\nKawh\n",
    "iv": "N1XbQhQOE/3u338ubzJx+g==\n",
    "version": 1,
    "cipher": "aes-256-cbc"
  }
}
```

Viewing the unencrypted contents of this file requires another `knife`
invocation, and puts your fixture data another step away from easy access.
Writing tests for infra code generally sucks- this just makes it harder.

Using this gem means you can store the data bag from above as:

```json
{
  "id": "aws_keys",
  "secret_access_key": "SECRET_ACCESS_KEY"
}
```

And it will be encrypted on the way into your sandbox machine with the given
secret found in `encrypted_data_bag_secret_key_path`. This means you can use
this data bag as `Chef::EncryptedDataBagItem.load("aws_keys")` in your
cookbooks, while keeping your JSON fixture unencrypted and readable.

Besides meaning you can edit fixtures directly in your chosen editor, there is
the added bonus that anyone viewing your changes in diff can immediately see
what has been changed.

## Tests

kitchen-encrypt-databags has both unit and integration tests. The unit tests
are written with [RSpec](http://rspec.info/), and can be invoked with `bundle
exec rspec`. These test provisioning of a testing sandbox using temporary files
on the local machine, and should hit each edge case.

To verify the encryption process works correctly with test-kitchen, we also run
tests against a fake cookbook located at `test/fixtures/cookbooks/fake`. This
cookbook creates a file using contents of an encrypted data bag, then asserts
that the content was decrypted correctly. These tests can be invoked with
`bundle exec kitchen test`.

## Contributing

Pull requests are welcome. Please fork the repo, then make a pull request from
your branch to the main repository. Report any issues in the Github Issue
Tracker.

## Authors

Lawrence Jones (lawrjone@gmail.com)

## License

MIT

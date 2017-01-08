# kitchen-encrypt-databags

This gem extends the ChefZero provisioner for
(test-kitchen)[https://github.com/test-kitchen/test-kitchen] so that the data
bags provisioned in the target machine sandbox are encrypted during the
provisioning phase.

Just add `gem 'kitchen-encrypt-databags'` to your `Gemfile` and select the
`chef_zero_encrypt_databags` provisioner in your `.kitchen.yml` like so:

```yaml
---
driver:
  name: docker

provisioner:
  name: chef_zero_encrypt_databags
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

Which you can edit with your standard system editor, no fuss, with the added
bonus that anyone viewing your changes in a PR or diff can immediately see what
has been changed.

## Contributing

Pull requests are welcome. Please fork the repo, then make a pull request from
your branch to the main repository. Report any issues in the Github Issue
Tracker.

## Authors

Lawrence Jones (lawrjone@gmail.com)

## License

MIT

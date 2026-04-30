This directory is structured so it can be used as the contents of the
`osl-incubator/homebrew-makim` tap repository.

Layout:

- `Formula/makim.rb`: generated Homebrew formula
- `scripts/generate_formula.sh`: renders the formula from release inputs
- `scripts/publish_tap.sh`: publishes the generated formula into the tap repo
- `scripts/test.sh`: smoke test for formula generation

The release workflow in this repository generates `Formula/makim.rb` here and
then pushes it to the dedicated tap repository.

Local testing:

```bash
bash homebrew/scripts/test.sh
```

Manual generation:

```bash
bash homebrew/scripts/generate_formula.sh \
  --version 1.2.3 \
  --repo osl-incubator/makim \
  --amd64-sha256 <amd64_sha256> \
  --arm64-sha256 <arm64_sha256> \
  --output homebrew/Formula/makim.rb
```

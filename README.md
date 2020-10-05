# DX::Api

A ruby client to access the DNAnexus API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dx-api'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install dx-api
```

## Usage

```ruby
DX::Api::Search.find_data_objects(
  api_token: YOUR_API_TOKEN,
  project_id: "project-1234",
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Publishing

Bump the ruby version to an appropriate number. When new code in the `lib` folder is pushed to the `main` branch, github actions will automatically build the gem and publish it to ASTOR-OSTOR's private registry.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DX::Api project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dx-api/blob/main/CODE_OF_CONDUCT.md).

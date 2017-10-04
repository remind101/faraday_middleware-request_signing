# Faraday request signing middleware

This middleware implements a portion of https://tools.ietf.org/html/draft-cavage-http-signatures-07.
Use it to sign cross-service requests.
See https://remind.quip.com/wSWRA4MAuTSz for more details.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'faraday_middleware-request_signing'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday_middleware-request_signing

## Usage

    connection = Faraday.new("http://myservice.example.org") do |conn|
      conn.request :request_signing, key_id: "test_key_id", key_secret: "test_key_secret"
      ...
    end

    ...

    conn.get("/test") # will send a request with signed "(request-target) host date" headers

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version and push git commits and tags.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/remind101/faraday_middleware-request_signing.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


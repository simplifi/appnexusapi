# Appnexus API Wrapper

An unofficial Ruby API Wrapper for the Appnexus Service APIs.

## Installation

Add this line to your application's Gemfile:

    gem 'appnexusapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appnexusapi

## Usage

Establish a connection:

    connection = AppnexusApi::Connection.new(
      'username' => 'username',
      'password' => 'password'

      # Defaults to connecting to https://api.appnexus.com/ but you can optionally pass a uri to
      # connect to another endpoint, e.g. the staging site could be
      # uri: 'http://api.sand-08.adnxs.net'
    )

Use a Service:

    member_service = AppnexusApi::MemberService.new(connection)
    # get always returns an array of results
    # and defaults "num_elements" to 100 and "start_element" to 0
    # and returns an AppnexusApi::Resource object which is a wrapper around the JSON
    member = member_service.get.first

    creative_service = AppnexusApi::CreativeService.new(connection, member.id)

    new_creative = {
      "content"   => "<iframe src='helloword.html'></iframe>",
      "width" => "300",
      "height" => "250",
      "template"  =>{ "id" => 7 }
    }
    creative = creative_service.create(new_creative)
    creative.update("campaign" => "Testing")

## Debugging

The APPNEXUS_API_DEBUG environment variable will trigger full printouts of Faraday's debug output to STDERR.

```bash
cd /my/app
export APPNEXUS_API_DEBUG=true
bundle exec rails whatever
```

## Testing

There is a rudimentary test suite that centers around creatives/creative_service.  To use it, you'll need to copy the `env_example` file to `.env` and replace the values with your correct values for your account. After that, a simple `bundle exec rspec spec` will run the test suite


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

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

    connection = AppnexusApi::Connection.new({
      # optionally pass a uri for the staging site
      # defaults to "http://api.adnxs.com/"
      # uri => "http://api.sand-08.adnxs.net",
      "username" => 'username',
      "password" => 'password'
    })

Use a Service:

    member_service = AppnexusApi::MemberService.new(connection)
    # get always returns an array of results
    # and defaults "num_elements" to 100 and "start_element" to 0
    # and returns an AppnexusApi::Resource object which is a wrapper around the JSON
    member = member_service.get.first

    creative_service = AppnexusApi::CreativeService.new(connection, member.id)

    new_creative = {
      "media_url" => "http://ad.doubleclick.net/adi/ABC.Advertising.com/DEF.40;sz=300x250;click0=",
      "width" => "300",
      "height" => "250",
      "format" => "url-html"
    }
    creative = creative_service.create(new_creative)
    creative.update("campaign" => "Testing")

## Debugging

The APPNEXUS_API_DEBUG environment variable will trigger full printouts of Faraday's debug output to STDERR.

```bash
cd /my/app
export LEANPLUM_API_DEBUG=true
bundle exec rails whatever
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

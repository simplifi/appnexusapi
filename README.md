# Appnexus API Wrapper

An unofficial Ruby API Wrapper for the Appnexus Service Console APIs.

_If you use the Appnexus Service Impression Bus API's, you may be more interested in this project:
https://github.com/simplifi/appnexusapi-impbus_


## Installation

Add this line to your application's Gemfile:

    gem 'appnexusapi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install appnexusapi

## Usage

#### Configure defaults
```ruby
AppnexusApi.configure do |config|
  config.logger = Logger.new('/path/to/log.log')
end
```

#### Establish a connection:

```ruby
connection = AppnexusApi::Connection.new(
  'username' => 'username',
  'password' => 'password',
  'logger'   => Logger.new(STDOUT) # defaults to STDOUT

  # Defaults to connecting to https://api.appnexus.com/ but you can optionally pass a uri to
  # connect to another endpoint, e.g. the staging site could be
  # "uri" => 'http://api-test.appnexus.com',
)
```

#### Use a Service:

```ruby
member_service = AppnexusApi::MemberService.new(connection)
# get always returns an array of results
# and defaults "num_elements" to 100 and "start_element" to 0
# and returns an AppnexusApi::Resource object which is a wrapper around the JSON
member = member_service.get.first

line_item_service = AppnexusApi::LineItemService.new(connection)
line_item = line_item_service.get.first
line_item = line_item_service.get({advertiser_id: 12345}).first

# create a new object
url_params  = { advertiser_id: 12345 }
body_params = { name: "some line item", code: "line item code"}

line_item = line_item_service.create(url_params, body_params)
line_item.state


# update an object
update_params = { state: "inactive" }
json_result = line_item.update(url_params, update_params)

# delete an object
line_item.delete(url_params)

# save an object that you modified locally
line_item.raw_json[:state] = 'active'
line_item.save

# this raises an AppnexusApi::UnprocessableEntity, not a 404 as it should
line_item_service.get(line_item.id)

new_creative = {
  "content"   => "<iframe src='helloword.html'></iframe>",
  "width" => "300",
  "height" => "250",
  "template"  =>{ "id" => 7 }
}
creative = creative_service.create(new_creative)
creative.update("campaign" => "Testing")
```

#### Downloading Log Level Data:

```ruby
download_service = AppnexusApi::LogLevelDataService.new(
  connection,
  downloaded_files_path: '/example/local/path',
  siphon_name: 'standard_feed'
)

downloaded_files = data_service.download_new_files_since('2016-02-01'.to_time)
```

## Testing

### Running Existing Specs
```
bundle exec rspec
```

### Writing New Specs or Updating Old Ones
This library uses [VCR](https://github.com/vcr/vcr) and Webmock to record API call HTTP data and play it back when you run the specs.  To write new specs or update old ones, however, you will need to actually provide a valid login/password in a `.env` file (see [`env_example`](env_example) for an example) before launching the specs.

To update a spec, simply remove the relevant file from [spec/fixtures/vcr](spec/fixtures/vcr) (and setup the username/password as above) before launching `rspec`; the changes will be recorded automatically by VCR.

## Debugging

To trigger full Faraday request/respone logging, set the `APPNEXUS_API_DEBUG` environment variable before launching
your application
```
export APPNEXUS_API_DEBUG=true
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Make changes (with tests -- at least integration tests, please)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

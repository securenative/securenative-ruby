<p align="center">
  <a href="https://www.securenative.com"><img src="https://user-images.githubusercontent.com/45174009/77826512-f023ed80-7120-11ea-80e0-58aacde0a84e.png" alt="SecureNative Logo"/></a>
</p>

<p align="center">
  <b>A Cloud-Native Security Monitoring and Protection for Modern Applications</b>
</p>
<p align="center">
  <a href="https://github.com/securenative/securenative-ruby">
    <img alt="Github Actions" src="https://github.com/securenative/securenative-ruby/workflows/CI/badge.svg">
  </a>
  <a href="https://codecov.io/gh/securenative/securenative-ruby">
    <img src="https://codecov.io/gh/securenative/securenative-ruby/branch/master/graph/badge.svg" />
  </a>
  <a href="https://badge.fury.io/rb/securenative"><img src="https://badge.fury.io/rb/securenative.svg" alt="Gem Version" height="18"></a>
</p>
<p align="center">
  <a href="https://docs.securenative.com">Documentation</a> |
  <a href="https://docs.securenative.com/quick-start">Quick Start</a> |
  <a href="https://blog.securenative.com">Blog</a> |
  <a href="">Chat with us on Slack!</a>
</p>
<hr/>


[SecureNative](https://www.securenative.com/) performs user monitoring by analyzing user interactions with your application and various factors such as network, devices, locations and access patterns to stop and prevent account takeover attacks.


## Install the SDK

Add this line to your application's Gemfile:

```ruby
gem 'securenative'
```

Then execute:

    $ bundle install

Or install it yourself as:

    $ gem install securenative

## Initialize the SDK

To get your *API KEY*, login to your SecureNative account and go to project settings page:

### Option 1: Initialize via Config file
SecureNative can automatically load your config from *securenative.yml* file or from the file that is specified in your *SECURENATIVE_CONFIG_FILE* env variable:

```ruby
require 'securenative'


secureative =  SecureNative.init
```
### Option 2: Initialize via API Key

```ruby
require 'securenative'


securenative =  SecureNative.init_with_api_key('YOUR_API_KEY')
```

### Option 3: Initialize via ConfigurationBuilder
```ruby
require 'securenative'


options = ConfigurationBuilder.new(api_key: 'API_KEY', max_events: 10, log_level: 'ERROR')
SecureNative.init_with_options(options)                                 
```

## Getting SecureNative instance
Once initialized, sdk will create a singleton instance which you can get: 
```ruby
require 'securenative'


secureNative = SecureNative.instance
```

## Tracking events

Once the SDK has been initialized, tracking requests sent through the SDK
instance. Make sure you build event with the EventBuilder:

 ```ruby
require 'securenative'
require 'models/event_options'
require 'enums/event_types'
require 'models/user_traits'


def track
    securenative = SecureNative.instance
    context = SecureNativeContext.new(client_token: 'SECURED_CLIENT_TOKEN', ip: '127.0.0.1',
                                       headers: { 'user-agent' => 'Mozilla: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.3 Mozilla/5.0 (Macintosh; Intel Mac OS X x.y; rv:42.0) Gecko/20100101 Firefox/43.4' })
    
    event_options = EventOptions.new(event: EventTypes::LOG_IN, user_id: '1234', context: context,
                                     user_traits: UserTraits.new(name: 'Your Name', email: 'name@gmail.com', phone: '+1234567890'),
                                     properties: { custom_param1: 'CUSTOM_PARAM_VALUE', custom_param2: true, custom_param3: 3 })
    
    securenative.track(event_options)
    
    @message = 'tracked'
end
 ```

You can also create request context from requests:

```ruby
require 'securenative'
require 'models/event_options'
require 'enums/event_types'
require 'models/user_traits'


def track(request)
    securenative = SecureNative.instance
    context = SecureNativeContext.from_http_request(request)
    
    event_options = EventOptions.new(event: EventTypes::LOG_IN, user_id: '1234', context: context,
                                     user_traits: UserTraits.new(name: 'Your Name', email: 'name@gmail.com', phone: '+1234567890'),
                                     properties: { custom_param1: 'CUSTOM_PARAM_VALUE', custom_param2: true, custom_param3: 3 })
    
    securenative.track(event_options)
    
    @message = 'tracked'
end
```

## Verify events

**Example**

```ruby
require 'securenative'
require 'models/event_options'
require 'enums/event_types'
require 'models/user_traits'


def verify(request)
    securenative = SecureNative.instance
    context = SecureNativeContext.from_http_request(request)

    event_options = EventOptions.new(event: EventTypes::LOG_IN, user_id: '1234', context: context,
                                         user_traits: UserTraits.new(name: 'Your Name', email: 'name@gmail.com', phone: '+1234567890'),
                                         properties: { custom_param1: 'CUSTOM_PARAM_VALUE', custom_param2: true, custom_param3: 3 })
    
    verify_result = securenative.verify(event_options)
    verify_result.risk_level  # Low, Medium, High
    verify_result.score  # Risk score: 0 -1 (0 - Very Low, 1 - Very High)
    verify_result.triggers  # ["TOR", "New IP", "New City"]
end
```

## Webhook signature verification

Apply our filter to verify the request is from us, for example:

```ruby
require 'securenative'


def webhook_endpoint(request)
    securenative = SecureNative.instance
    
    # Checks if request is verified
    is_verified = securenative.verify_request_payload(request)
end
 ```
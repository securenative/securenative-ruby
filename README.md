# SecureNative
**[SecureNative](https://www.securenative.com/) is rethinking-security-as-a-service, disrupting the cyber security space and the way enterprises consume and implement security solutions.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'securenative'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install securenative

## Initialize the SDK
Retrieve your API key from settings page of your SecureNative account and use the following in your code to initialize and use the sdk.
```ruby
require 'securenative'

# Do some cool stuff here
# ...
# ...
 
begin
  SecureNative.init('YOUR_API_KEY') # Should be called before any other call to securenative
rescue SecureNativeSDKException => e
  # Do some error handling
end
```

## Tracking events
Once the SDK has been initialized, you can start sending new events with the `track` function:
```ruby
require 'securenative'
require 'securenative/event_type'


def login
  # Do some cool stuff here
  # ...
  # ...
  
  SecureNative.track(Event.new(
            event_type = EventTypes::LOG_IN,
            user: User.new("1", "Jon Snow", "jon@snow.com"),
            ip: "1.2.3.4",
            remote_ip: "5.6.7.8",
            user_agent: "Mozilla/5.0 (Linux; U; Android 4.4.2; zh-cn; GT-I9500 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/5.0 QQ-URL-Manager Mobile Safari/537.36",
            sn_cookie: "cookie"))
end
```

## Verification events
Once the SDK has been initialized, you can start sending new events with the `verify` function:
```ruby
require 'securenative'
require 'securenative/event_type'


def reset_password   
    res = SecureNative.verify(Event.new(
              event_type = EventTypes::PASSWORD_RESET,
              user: User.new("1", "Jon Snow", "jon@snow.com"),
              ip: "1.2.3.4",
              remote_ip: "5.6.7.8",
              user_agent: "Mozilla/5.0 (Linux; U; Android 4.4.2; zh-cn; GT-I9500 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 MQQBrowser/5.0 QQ-URL-Manager Mobile Safari/537.36",
              sn_cookie: "cookie"))
                  
    if res['riskLevel'] == 'high'
        return 'Cannot change password'
    else res['riskLevel'] == 'medium'
        return 'MFA'
     end   
end
```

## Using webhooks
You can use the SDK to verify incoming webhooks from SecureNative, just call the `veriy_webhook` function which return a boolean which indicates if the webhook came from Secure Native servers.
```ruby
require 'securenative'

begin
  SecureNative.init('YOUR_API_KEY') # Should be called before any other call to securenative
rescue SecureNativeSDKException => e
  # Do some error handling
end

def handle_some_code(headers, body)
  sig_header = headers["X-SecureNative"]
  if SecureNative.verify_webhook(sig_header, body)
      # Handle the webhook
      level = body['riskLevel']
  else
      # This request wasn't sent from Secure Native servers, you can dismiss/investigate it
  end
end
```

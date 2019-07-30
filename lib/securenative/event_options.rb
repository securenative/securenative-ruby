require 'securerandom'

class User
  def initialize(user_id: "", user_email: "", user_name: "")
    @user_id = user_id
    @user_email = user_email
    @user_name = user_name
  end

  attr_reader :user_id
  attr_reader :user_email
  attr_reader :user_name
end

class Event
  def initialize(event_type, user: User(), ip: "127.0.0.1", remote_ip: "127.0.0.1", user_agent: "unknown", sn_cookie: nil, params: nil)
    @event_type = event_type
    @user = user
    @ip = ip
    @remote_ip = remote_ip
    @user_agent = user_agent
    @cid = ""
    @fp = ""

    if params
      unless params.length > 0 && params[0].instance_of?(CustomParam)
        raise ArgumentError("custom params should be a list of CustomParams")
      end
    end
    @params = params

    if sn_cookie
      @cid, @cid = Utils.parse_cookie(sn_cookie)
    end
    @vid = SecureRandom.uuid
    @ts = Time.now.getutc.to_i
  end

  def to_hash
    p = Array.new
    if @params
      @params.each do |param|
        p << {:key => param.key, :value => param.value}
      end
    end

    {
        :eventType => @event_type,
        :user => {
            :id => @user.user_id,
            :email => @user.user_email,
            :name => @user.user_name
        },
        :remoteIP => @remote_ip,
        :ip => @ip,
        :cid => @cid,
        :fp => @fp,
        :ts => @ts,
        :vid => @vid,
        :userAgent => @user_agent,
        :device => Hash.new,
        :params => p
    }
  end

  attr_reader :cid
  attr_reader :params
  attr_reader :user_agent
  attr_reader :user
  attr_reader :remote_ip
  attr_reader :event_type
  attr_reader :fp
  attr_reader :ip
  attr_reader :ts
  attr_reader :vid
end

class CustomParam
  def initialize(key, value)
    @key = key
    @value = value
  end

  attr_reader :key
  attr_reader :value
end

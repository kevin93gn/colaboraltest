module ModuleItemsHelper

  require 'rubygems'
  require 'base64'
  require 'cgi'
  require 'openssl'
  require "json"

  DISQUS_SECRET_KEY = 'gPv7pX6JMjG8QRAWXuKexiWRucmqPrzqdCLOnSdsLlJa1yIgqmgSIvkzP55UfPqH'
  DISQUS_PUBLIC_KEY = '8EIVO22yXDUfJUdYUVqvnwQKI8lFxAl2WpsAoTBzCxe2aLoogzf8SqRH0biSVotw'

  def get_disqus_sso(user)
    # create a JSON packet of our data attributes
    data = 	{
        'id' => user['id'],
        'username' => user['email'],
        'email' => user['email']
        #'avatar' => user['avatar'],
        #'url' => user['url']
    }.to_json

    # encode the data to base64
    message  = Base64.encode64(data).gsub("\n", "")
    # generate a timestamp for signing the message
    timestamp = Time.now.to_i
    # generate our hmac signature
    sig = OpenSSL::HMAC.hexdigest('sha1', DISQUS_SECRET_KEY, '%s %s' % [message, timestamp])

    # return a script tag to insert the sso message
    return "<script type=\"text/javascript\">
        var disqus_config = function() {
            this.page.remote_auth_s3 = \"#{message} #{sig} #{timestamp}\";
            this.page.api_key = \"#{DISQUS_PUBLIC_KEY}\";
        }
	</script>"
  end

  def get_disqus_auth(user)
    # create a JSON packet of our data attributes
    data = 	{
        'id' => user['id'],
        'username' => user['email'],
        'email' => user['email']
        #'avatar' => user['avatar'],
        #'url' => user['url']
    }.to_json

    # encode the data to base64
    message  = Base64.encode64(data).gsub("\n", "")
    # generate a timestamp for signing the message
    timestamp = Time.now.to_i
    # generate our hmac signature
    sig = OpenSSL::HMAC.hexdigest('sha1', DISQUS_SECRET_KEY, '%s %s' % [message, timestamp])
    #remote_auth_s3 = "#{message} #{sig} #{timestamp}"
    #return remote_auth_s3

    # return a script tag to insert the sso message
    return "<script type=\"text/javascript\">
        var disqus_config = function() {
            this.page.remote_auth_s3 = \"#{message} #{sig} #{timestamp}\";
            this.page.api_key = \"#{DISQUS_PUBLIC_KEY}\";
        }
	</script>"
  end

  def get_disqus_logout
    # create a JSON packet of our data attributes
    data = 	{
    }.to_json

    # encode the data to base64
    message  = Base64.encode64(data).gsub("\n", "")
    # generate a timestamp for signing the message
    timestamp = Time.now.to_i
    # generate our hmac signature
    sig = OpenSSL::HMAC.hexdigest('sha1', DISQUS_SECRET_KEY, '%s %s' % [message, timestamp])
    #remote_auth_s3 = "#{message} #{sig} #{timestamp}"
    #return remote_auth_s3

    # return a script tag to insert the sso message
    return "<script type=\"text/javascript\">
        var disqus_config = function() {
            this.page.remote_auth_s3 = \"#{message} #{sig} #{timestamp}\";
            this.page.api_key = \"#{DISQUS_PUBLIC_KEY}\";
        }
	</script>"
  end

end

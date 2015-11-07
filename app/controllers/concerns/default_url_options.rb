module DefaultUrlOptions

  # Including this file sets the default url options. This is useful for mailers or background jobs

  def default_url_options
    { :host => host, :port => port  }
  end

private

  def host

    # Your logic for figuring out what the hostname should be
    # request = Thread.current[:request]
    subdomain = request.subdomain
    
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    # host = Rails.application.config.action_mailer.default_url_options[:host]
    host = request.domain.blank? ? "0.0.0.0" : request.domain
    [subdomain, host].join
   end

  def port
    # Your logic for figuring out what the port should be
    # request = Thread.current[:request]
    request.port
  end

end
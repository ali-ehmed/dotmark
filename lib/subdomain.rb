class Subdomain
  def self.matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
    	account = $redis.get("#{request.subdomain}")
    	
	    if account.nil?
	      account = Account.find_by(subdomain: request.subdomain)
	      $redis.set("#{request.subdomain}", account)
	    end
	    account = JSON.load(account)

      if account
        return true # -> if account is not found, return false (IE no route)
      end
    end
  end
end
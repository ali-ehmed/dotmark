class Subdomain
  def self.matches?(request)
    if request.subdomain.present? && request.subdomain != 'www'
      account = Account.find_by subdomain: request.subdomain
      if account
        return true # -> if account is not found, return false (IE no route)
      end
    end
  end
end
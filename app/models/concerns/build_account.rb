module BuildAccount
	def set_account
    @account = build_account
    @account.subdomain = username
    @account.save
  end
end
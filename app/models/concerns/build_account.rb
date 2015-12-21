module BuildAccount
	def set_account
    @account = build_account
    @account.subdomain = self.username
    @account.save
  end
end
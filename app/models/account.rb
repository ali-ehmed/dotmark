# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  subdomain     :string
#  resource_type :string
#  resource_id   :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  is_active     :boolean          default(FALSE)
#

class Account < ActiveRecord::Base
	belongs_to :resource, polymorphic: true, dependent: :delete
end

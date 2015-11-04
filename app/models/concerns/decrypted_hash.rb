class DecryptedHash
	extend ActiveSupport::Concern

	def decrypt_hash(temp_string)
    cipher_key = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    decrypted_data = cipher_key.decrypt_and_verify(temp_string)
    decrypted_data
  end
end
class StringEncryptor
	extend ActiveSupport::Concern

	def decrypt_hash(temp_string)
    cipher_key = ActiveSupport::MessageEncryptor.new(Dotmark::Application.secrets.secret_key_base)
    decrypted_data = cipher_key.decrypt_and_verify(temp_string)
    decrypted_data
  end

  def encrypt_hash(string)
  	cipher_key = ActiveSupport::MessageEncryptor.new(Dotmark::Application.secrets.secret_key_base)
    encryted_data = cipher_key.encrypt_and_sign(string)

    encryted_data
  end
end
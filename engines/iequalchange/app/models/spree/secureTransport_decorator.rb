require "base64"
require "digest"
require "openssl"

module IEqualChange
	class SecureTransport
		def initialize(key)
			@key = key
		end

		def key_create
			digest = Digest::SHA256.new
			return digest.digest(@key)
		end

		def encrypt(payload)
			prefix = "iEC"
			                  #name-key length-mode
			cipher_protocol = 'aes-256-cbc'

			cipher = OpenSSL::Cipher::Cipher.new(cipher_protocol)
			cipher.encrypt
			cipher.key = self.key_create()
			iv = cipher.random_iv

			encrypted = cipher.update(payload) + cipher.final

			final_payload = prefix + 2.chr + iv + encrypted

			return Base64.strict_encode64(final_payload)
		end
	end
end

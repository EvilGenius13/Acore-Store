# app/services/registration_service.rb
class RegistrationService
  N = 0x894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7.to_bn
  G = 7.to_bn

  def register_user(user_params)
    puts "Checking user params:", user_params
    username = user_params[:username]
    password = user_params[:password]

    if password.length > 16
      return { status: :error, error: "Password cannot exceed 16 characters" }
    end

    if username_exists?(username)
      return { status: :error, error: "Username already exists." }
    end

    salt, verifier = hash_password(username, password)
    if save_to_database(username, salt, verifier)
      { status: :success, message: "User registered successfully" }
    else
      { status: :error, error: "Database error" }
    end
  end

  private

  def username_exists?(username)
    AzerothUser.where(username: username).exists?
  end

  def hash_password(username, password)
    username = username.upcase
    password = password.upcase
    salt = OpenSSL::Random.random_bytes(32)
    hash1 = OpenSSL::Digest::SHA1.new("#{username}:#{password}").digest
    hash2 = OpenSSL::Digest::SHA1.new(salt + hash1).digest
    verifier = G.mod_exp(hash2.unpack1('H*').hex, N)
  
    # Convert GMP number back to binary and ensure it is exactly 32 bytes
    verifier_bytes = [verifier.to_s(16)].pack('H*')
    verifier_bytes = verifier_bytes[0...32]  # Ensure it is exactly 32 bytes
    [salt, verifier_bytes]
  end

  def save_to_database(username, salt, verifier)
    AzerothUser.create(username: username, salt: salt, verifier: verifier)
  end
end

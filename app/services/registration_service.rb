require 'openssl'

class RegistrationService
  # Constants
  N = OpenSSL::BN.new('894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7', 16)
  G = OpenSSL::BN.new('7', 10)

  def register_user(user_params)
    username = user_params[:username]
    password = user_params[:password]

    return { status: :error, error: "Password cannot exceed 16 characters" } if password.length > 16
    return { status: :error, error: "Username already exists." } if username_exists?(username)

    salt, verifier = hash_password(username, password)
    if save_to_database(username, salt, verifier)
      { status: :success, message: "User registered successfully" }
    else
      { status: :error, error: "Database error" }
    end
  end

  def hash_password(username, password)
    username = username.upcase
    password = password.upcase
    salt = OpenSSL::Random.random_bytes(32)
    h1 = OpenSSL::Digest::SHA1.digest("#{username}:#{password}")
    h2 = OpenSSL::Digest::SHA1.digest(salt + h1)

    # Convert binary h2 to a big number in little-endian
    h2_bn = OpenSSL::BN.new(h2.reverse.unpack('H*').first, 16)
    verifier = G.mod_exp(h2_bn, N)

    # Convert verifier to binary little-endian byte array
    verifier_bytes = [verifier.to_s(16)].pack('H*').reverse.ljust(32, "\x00")
    [salt, verifier_bytes]
  end

  def verify_password(username, password, stored_salt, stored_verifier)
    username = username.upcase
    password = password.upcase
  
    # Recreate h1 using the input username and password
    h1 = OpenSSL::Digest::SHA1.digest("#{username}:#{password}")
  
    # Recreate h2 using the stored salt and the newly created h1
    h2 = OpenSSL::Digest::SHA1.digest(stored_salt + h1)
  
    # Convert binary h2 to a big number in little-endian
    h2_bn = OpenSSL::BN.new(h2.reverse.unpack('H*').first, 16)
  
    # Compute verifier
    computed_verifier = G.mod_exp(h2_bn, N)
  
    # Convert verifier to binary little-endian byte array and ensure it is 32 bytes long
    computed_verifier_bytes = [computed_verifier.to_s(16)].pack('H*').reverse.ljust(32, "\x00")
  
    # Compare the computed verifier with the stored verifier
    computed_verifier_bytes == stored_verifier
  end

  private

  def username_exists?(username)
    AzerothUser.where(username: username).exists?
  end

  def save_to_database(username, salt, verifier)
    AzerothUser.create(username: username, salt: salt, verifier: verifier)
  end
end

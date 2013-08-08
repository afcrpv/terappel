# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
def find_secret_token
  Rails.env.production? ? ENV['APP_SECRET_TOKEN'] : 'a40c208f451e0b31b0d55d1dcc9eff2c24188ec3cedc5fba0c682a804c70ac6f63844b34e37c6bece962f5ab0249d8a022bdcc9bd8c0a9b76e0d67757226a3a9'
end

Terappel::Application.config.secret_key_base = find_secret_token

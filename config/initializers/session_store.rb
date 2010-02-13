# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_jssamples_session',
  :secret      => '2db28fd42e181465865b8128121a8fe1580e9cc0b716c339a74564d6c3aaeb9ecf23924525bd6f1d7c403d1bd28f523fa669555fc763e752e75c032d21d0b691'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

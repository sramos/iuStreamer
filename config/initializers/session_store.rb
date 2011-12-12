# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_webStream_session',
  :secret      => '995e36ba13ab41cdec7fa705fee5790f67598663d910229789b7125ebecbc9efd1f8ccf1f8a9c8865193a6d848d1d70bf7cd13f7b9d88ac8209808d91f4b507e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

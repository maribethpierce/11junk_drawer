require 'sinatra'
require 'shotgun'
require 'openssl'

Set-Cookie: visit_count=1; Expires=Sun, 16 Aug 2015 10:15:00 GMT

def generate_hmac(data, secret)
  OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, secret, data)
end

use Rack::Sessions::Cookie, {
  secret: "change-me",
  expire_after: 86400 #seconds (about a day)
}
#this (above) results in "session" data being associated with this visit.
#the session data can then be referenced in the app to be sure it's the same user_score
#Think of it kind of like a bouncer...


get "/" do
  # Check to see if the session contains a visit counter already. If this is
  # the first time visiting the site the value will be nil.
  if session[:visit_count].nil?
    visit_count = 1
  else
    # Everything in the session is stored as key-value strings. We need to
    # convert back to an integer before we can use this value in our app.
    visit_count = session[:visit_count].to_i
  end

  session[:visit_count] = visit_count + 1

  "You've visited this page #{visit_count} time(s).\n"
end

require 'digest/sha1'

class Mailer < ActionMailer::Base
  
  def lost_password(user)
    new_password = Digest::SHA1.hexdigest(" #{rand(10**10)} #{rand(10**10)}")[0..15]
    user.password = new_password
    user.save
    recipients user.email
    subject "your new movierok password"
    from "info@movierok.org"
    body :user => user, :new_password => new_password
  end

end

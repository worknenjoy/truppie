# Preview all emails at http://localhost:3000/rails/mailers/organizer_mailer
class OrganizerMailerPreview < ActionMailer::Preview
  
  def organizer_notify
    OrganizerMailer.notify(Organizer.last, "activate")
  end
  
  def organizer_notify_update
    OrganizerMailer.notify(Organizer.last, "update")
  end

  def organizer_invite
    OrganizerMailer.invite(Organizer.last)
  end

end

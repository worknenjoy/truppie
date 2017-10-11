MailyHerald.setup do |config|

  config.context :active_users do |context|
    context.scope { User.all }
    context.destination {|user| user.email}

    # Alternatively, you can specify destination as attribute name:
    # context.destination = :email
  end

  # Put your contexts and mailing definitions here
end

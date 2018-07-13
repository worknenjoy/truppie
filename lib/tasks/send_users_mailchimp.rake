require 'benchmark'
require 'rest_client'
require 'uri'
require 'digest'

namespace :send_users_mailchimp do

  desc "TODO"
  task sync: :environment do
    send_users
    send_organizer_users
  end


  task send_users: :environment do
    send_users
  end

  task send_organizer_users: :environment do
    send_organizer_users
  end


  def send_users
    puts 'Start send_users...'
    users = User.all

    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_KEY'], symbolize_keys: true)
    gibbon.timeout = 10
    gibbon.symbolize_keys = true
    gibbon.debug = false
    # 0 => EMAIL, 1 => FNAME, 2 => LNAME
    users.each do |user|
      begin
        gibbon.lists(ENV['MAILCHIMP_LIST_ID'])
              .members
              .create(body: { email_address: user.email,
                              status: 'subscribed' })
      rescue Gibbon::MailChimpError => e
        puts "Email já cadastrado: #{user.email}"
        puts 'Processo não terminou, adicionando . . .'
      end
    end
    puts 'DONE !'
  end

  def send_organizer_users
    puts 'Start send_organizer_users...'
    organizer_users = Organizer.all
    gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_KEY'], symbolize_keys: true)
    gibbon.timeout = 10
    gibbon.symbolize_keys = true
    gibbon.debug = false
    # 0 => EMAIL, 1 => FNAME, 2 => LNAME
    organizer_users.each do |organizer_user|
      begin
        gibbon.lists(ENV['MAILCHIMP_LIST_ID'])
              .members
              .create(body: { email_address: organizer_user.email,
                              status: 'subscribed' })
      rescue Gibbon::MailChimpError => e
        puts "Email já cadastrado: #{organizer_user.email}"
        puts 'Processo não terminou, adicionando . . .'
      end
    end
    puts 'DONE !'
  end


end

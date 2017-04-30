require 'test_helper'

class TransferMailerTest < ActionMailer::TestCase
  test "a new transfer in transit" do
    o = organizers(:mkt)

    @status_class = "alert-success"
    @subject = "Uma nova transferência foi realizada"
    @mail_first_line = "Uma nova transferência foi solicitada"
    @mail_second_line = "Uma transferência no valor de 1880 foi realizada para sua conta"

    @status_data = {
        subject: @subject,
        mail_first_line: @mail_first_line,
        mail_second_line: @mail_second_line,
        status_class: @status_class
    }

    mail = TransferMailer.transfered(o, @status_data).deliver_now

    #puts ActionMailer::Base.deliveries[0].html_part

    assert_not ActionMailer::Base.deliveries.empty?
    #assert_equal ActionMailer::Base.deliveries[0].html_part.to_s.include?('criada'), true
    assert_equal ["ola@truppie.com"], mail.from
    assert_equal ["MyString"], mail.to
    assert_equal "Uma nova transferência foi realizada", mail.subject
  end
end

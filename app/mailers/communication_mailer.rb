
class CommunicationMailer < ActionMailer::Base
  default from: 'mensaje@colaboral.com'

  def communication_mail(message, users, sender)
    recipients = Array.new
    users.push(sender)
    users.each  do |u|
      recipients.push(u.email)
    end
    @content = message.content
    mail(bcc: recipients, subject: message.subject)
  end

  def test_mail
    mail(bcc: 'xavier@it4.cl', subject: 'Sample Email')
  end

end

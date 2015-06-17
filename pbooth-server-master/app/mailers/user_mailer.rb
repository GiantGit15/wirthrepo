class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_gif_email(content)
    content = OpenStruct.new(content)

    send_to = content.name ? "#{content.name} <#{content.email}>" : content.email 
    subject = content.subject || ""

    body = content.body || ""

    if content.photoset_id
      #attachments.inline["rails.gif"] = File.read("#{Rails.root}/public/images/rails.png")
    end

    mail(:to => send_to, :subject => subject)
  end

end

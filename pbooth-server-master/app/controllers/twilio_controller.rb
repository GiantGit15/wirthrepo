#require 'twilio-ruby'
class TextMessageController < ApplicationController
  def twilio

    # # set up a client to talk to the Twilio REST API
    @client = Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"]
    
    twilio_phone_number = ENV["TWILIO_NUMBER"]
    number_to_send_to = "732-500-4295"
             
                 
    @client.account.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "This is an message. It gets sent to #{number_to_send_to}",
      :media_url => "https://vb100.s3.amazonaws.com/uploads/article/image/520ab69b1d7137971e000002/800px-Brighton_West_Pier__England_-_Oct_2007.jpg?AWSAccessKeyId=AKIAI2WNS2PPQL26DORA&Signature=UzfniKscmU7T1fykw92qHCEDwVo%3D&Expires=1397841235" )

    redirect_to root
  end
  
  def mogreet
    client = Mogreet::Client.new('6174', 'dc56d8339f6b13af7e09c08b842fd5d9')

    response = client.system.ping
    puts response.message

    response = client.transaction.send(
        :campaign_id => 69016, 
        :to          => '13479132050', 
        :message     => 'hello', 
        :content_url => 'http://uberhumor.com/wp-content/uploads/2014/04/CaJ24lp.gif'
    )

    redirect_to root
  end
end



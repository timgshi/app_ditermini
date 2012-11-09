class SmsController < ApplicationController

  def send_text_message
    number_to_send_to = params[:number_to_send_to]
    message = params[:message]

    twilio_sid = "AC8843247b03a215017d76bce8b346acd6"
    twilio_token = "03782e92f8e0f4154030465ca2b00cef"
    twilio_phone_number = "6502657846"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => message
    )
  end
  
end

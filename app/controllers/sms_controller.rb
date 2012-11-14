class SmsController < ApplicationController

  def send_text_message
    number_to_send_to = params[:number_to_send_to]
    message = params[:message]
    @photo = Photo.find(params[:photo_id])
    message = "Your friend #{current_user.name} would like you to vote on their outfit! Click here to vote: #{url_for(@photo)}"
    twilio_sid = ENV['TWILIO_SID']
    twilio_token = ENV['TWILIO_TOKEN']
    twilio_phone_number = "6502657846"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    @message = @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => message
    )
    render :layout => false, :status => :ok, :text => @message
  end
  
end

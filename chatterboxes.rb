require 'sinatra'
require 'dotenv'
require 'pony'
require 'mailchimp'
require 'gibbon'

Dotenv.load

def send_mail(name, email, phone, message=nil)
  if message == nil
    erb_template = :contact_email
    body = "Hey Brittany,\n\t#{name} is interested in an appointment Chatterboxes.  They can be reached via email at #{email} or by phone at #{phone}."
  else
    erb_template = :message_email
    body = "Hey Brittany,\n\t New message from #{name}:  \n #{message} \n They can be reached via email at #{email} or by phone at #{phone}."
  end

  Pony.mail({
    to: "murphydbuffalo@gmail.com",
    from: "Web-Services@teamchatterboxes.com",
    subject: "Someone is interested in an appointment at Chatterboxes!",
    html_body: erb(erb_template),
    body: body,
    via: :smtp,
    via_options: {
      :address        => 'smtp.mandrillapp.com',
      :port           => '587',
      :user_name      => ENV['MANDRILL_USERNAME'],
      :password       => ENV['MANDRILL_APIKEY'],
      :authentication => :plain, 
      :domain         => "heroku.com"
    }
  })
end

def subscribe_to_mail_chimp(email)
  gibbon = Gibbon::API.new
  gibbon.lists.subscribe({
    :id => ENV['MAILCHIMP_LIST_ID'], 
    :email => { :email => email },
    :double_optin => true 
  })
rescue Gibbon::MailChimpError => error
  puts error.message
  puts "Error code is: #{error.code}"
  redirect '/home'
  @error_message = error.message
end

get '/' do
  redirect '/home'
end

get '/home' do
  erb :home, layout: :application
end

post '/mailchimp' do
  @email = params[:email]
  subscribe_to_mail_chimp(@email)
  redirect '/home'
end

post '/contact' do
  if params[:last_name] != nil
    @full_name = "#{params[:first_name].capitalize} #{params[:last_name].capitalize}"
  else
    @full_name = "#{params[:first_name].capitalize}"
  end

  @phone = params[:phone]
  @email = params[:email]
  @message = params[:message]

  send_mail(@full_name, @email, @phone, @message)

  redirect '/home'
end

get '/about' do
  erb :about, layout: :application
end

get '/contact' do
  erb :contact, layout: :application
end

get '/services' do
  erb :services, layout: :application
end

get '/started' do
  erb :started, layout: :application
end


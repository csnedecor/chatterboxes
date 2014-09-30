require 'sinatra'
require 'dotenv'
require 'pony'
require 'mailchimp'
require 'gibbon'

Dotenv.load

def mail_to(recipient, name, email, phone)
  Pony.mail({
    to: recipient,
    from: "Web-Services@teamchatterboxes.com",
    subject: "Someone is interested in an appointment at Chatterboxes!",
    html_body: erb(:email),
    body: "Hey Brittany,\n\t#{name} is interested in Chatterboxes!  They can be reached via email at #{email} or by phone at #{phone}.",
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

post '/home' do
  @full_name = "#{params[:first_name].capitalize} #{params[:last_name].capitalize}"
  @phone = params[:phone]
  @email = params[:email]

  mail_to("murphydbuffalo@gmail.com", @full_name, @email, @phone)

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


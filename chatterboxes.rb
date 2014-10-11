require 'sinatra'
require 'dotenv'
require 'pony'
require 'mailchimp'
require 'gibbon'

Dotenv.load

def send_mail(name, email, phone, message=nil)
  body =  
    '''
    Hi Brittany,\n
      \t New message from #{name}:  \n 
      #{message} \n 
      They can be reached via email at #{email} or by phone at #{phone}.
    '''

  Pony.mail({
    to: 'murphydbuffalo@gmail.com',
    # to: 'brittany@teamchatterboxes.com',
    cc: 'megan@teamchatterboxes.com',
    # bcc: "murphydbuffalo@gmail.com",
    from: "Chatterboxes-Web-Services@teamchatterboxes.com",
    subject: "New message!",
    html_body: erb(:message_email),
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

def validate_presence_of(*params)
  params.all? { |p| p.length > 0 }
end

get '/' do
  redirect '/home'
end

post '/mailchimp' do
  @email = params[:email]
  subscribe_to_mail_chimp(@email)
  redirect '/home'
end

get '/home' do
  erb :home, layout: :application
end

post '/home' do
  if params[:last_name] != nil
    @full_name = "#{params[:first_name].capitalize} #{params[:last_name].capitalize}"
  else
    @full_name = "#{params[:first_name].capitalize}"
  end

  @phone = params[:phone]
  @email = params[:email]

  send_mail(@full_name, @email, @phone)

  redirect '/home'
end

get '/about' do
  erb :about, layout: :application
end

get '/contact' do
  erb :contact, layout: :application
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

get '/services' do
  erb :services, layout: :application
end

get '/started' do
  erb :started, layout: :application
end

post '/started' do
  @full_name = params[:name]
  @email = params[:email]
  @phone = params[:phone]
  @message = params[:message]
  send_mail(@full_name, @email, @phone, @message)

  redirect '/home'
end


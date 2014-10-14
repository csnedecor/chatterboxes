require 'sinatra'
require 'dotenv'
require 'pony'
require 'mailchimp'
require 'gibbon'

Dotenv.load

def send_mail(name, email, phone, message=nil)
  body =  
    "Hi Brittany,\n
    \t New message from #{name}:  \n 
    \t #{message} \n 
    \t They can be reached via email at #{email} or by phone at #{phone}."

  Pony.mail({
    # to: 'murphydbuffalo@gmail.com',
    bcc: 'murphydbuffalo@gmail.com',
    to: 'brittany@teamchatterboxes.com',
    cc: 'megan@teamchatterboxes.com',
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

  Pony.mail({
    to: email,
    from: "Chatterboxes-Web-Services@teamchatterboxes.com",
    subject: "Your message was sent!",
    html_body: erb(:confirmation_email),
    body: "Thank you for contacting Chatterboxes! A member of our team will be in touch with you shortly.",
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

def subscribe_to_mail_chimp(email, category)
  gibbon = Gibbon::API.new
  gibbon.lists.subscribe({
    :id => ENV['MAILCHIMP_LIST_ID'], 
    :email => { :email => email },
    :merge_vars => { :FNAME => category },
    :double_optin => true 
  })
rescue Gibbon::MailChimpError => error
  puts error.message
  puts "Error code is: #{error.code}"
end

def presence_valid?(*params)
  params.length > 0 && params.all? { |p| p.length > 0 }
end

get '/' do
  redirect '/home'
end

post '/mailchimp' do
  if presence_valid?(params[:email], params[:category])
    subscribe_to_mail_chimp(params[:email], params[:category])
    redirect '/home?newsletter=true'
  else
    puts 'Newsletter sign up error: blank fields'
    redirect '/home'
  end
end

get '/home' do
  erb :home, layout: :application
end

post '/home' do
  if presence_valid?(params[:first_name], params[:last_name], params[:email], params[:phone])
    @full_name = "#{params[:first_name].capitalize} #{params[:last_name].capitalize}"
    @phone = params[:phone]
    @email = params[:email]

    send_mail(@full_name, @email, @phone)
    redirect '/home?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/home'
  end
end

get '/about' do
  erb :about, layout: :application
end

get '/contact' do
  erb :contact, layout: :application
end

post '/contact' do
  if presence_valid?(params[:name], params[:message], params[:email], params[:phone])
    @full_name = "#{params[:name].capitalize}"
    @phone = params[:phone]
    @email = params[:email]
    @message = params[:message]

    send_mail(@full_name, @email, @phone, @message)
    redirect '/contact?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/contact'
  end
end

get '/services' do
  @therapy_id = params[:therapy_id] || 'none'
  erb :services, layout: :application
end

post '/services' do
  if presence_valid?(params[:first_name], params[:last_name], params[:email], params[:phone])
    @full_name = "#{params[:first_name].capitalize} #{params[:last_name].capitalize}"
    @phone = params[:phone]
    @email = params[:email]

    send_mail(@full_name, @email, @phone)
    redirect '/services?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/services'
  end
end

get '/started' do
  erb :started, layout: :application
end

post '/started' do
  if presence_valid?(params[:name], params[:message], params[:email], params[:phone])
    @full_name = "#{params[:name].capitalize}"
    @phone = params[:phone]
    @email = params[:email]
    @message = params[:message]

    send_mail(@full_name, @email, @phone, @message)
    redirect '/started?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/started'
  end

end


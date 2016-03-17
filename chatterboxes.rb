require 'sinatra'
require 'dotenv'
require 'pony'
require 'mailchimp'
require 'gibbon'
require 'rack-olark'
require 'pry'

Dotenv.load
use Rack::Olark, id: ENV['OLARK_SITE_ID']

# Mandrill app on heroku only allows 25 emails to be sent per hour,
# so there will be a delay when testing emails if you send more than 25.

def send_mail(name, email, phone, message=nil, location=nil, therapy_type=nil)
  body =
    "Hi Heather,\n
    \t New message from #{name}:  \n
    \t #{message} \n
    \t They can be reached via email at #{email} or by phone at #{phone}.
    \t Interested in: #{location} Location."

  Pony.mail({
    to: 'heather@teamchatterboxes.com',
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

def send_appointment_request(name, email, phone, date=nil, time=nil, service=nil)

  # Code for testing in development
  # Pony.mail :to => "coriannas@yahoo.com", :via =>:sendmail,
  #       :from => "Chatterboxes-Web-Services@teamchatterboxes.com", :subject => "New message!",
  #       :html_body => erb(:appointment_email)

  Pony.mail({
    to: 'heather@teamchatterboxes.com',
    cc: 'megan@teamchatterboxes.com',
    from: "Chatterboxes-Web-Services@teamchatterboxes.com",
    subject: "New message!",
    html_body: erb(:appointment_email),
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
  if params[:appointment_submit]
    if presence_valid?(params[:appointment_name], params[:appointment_email], params[:appointment_phone])
      @full_name = params[:appointment_name]
      @phone = params[:appointment_phone]
      @email = params[:appointment_email]
      @date = params[:appointment_date]
      @time = params[:appointment_time]
      @service = params[:appointment_service]

      send_appointment_request(@full_name, @email, @phone, @date, @time, @service)
      redirect '/home?mail=true'
    else
      puts 'Email error: blank fields'
      redirect '/home'
    end
  else
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
    @therapy_type = params[:therapy_type]

    send_mail(@full_name, @email, @phone, @therapy_type)
    redirect '/services?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/services'
  end
end

get '/ot' do
  @therapy_id = params[:therapy_id] || 'none'
  erb :ot, layout: :application
end

post '/ot' do
  if presence_valid?(params[:first_name], params[:last_name], params[:email], params[:phone])
    @full_name = "#{params[:first_name].capitalize} #{params[:last_name].capitalize}"
    @phone = params[:phone]
    @email = params[:email]
    @therapy_type = params[:therapy_type]

    send_mail(@full_name, @email, @phone, @therapy_type)
    redirect '/ot?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/ot'
  end
end

get '/started' do
  erb :started, layout: :application
end

post '/started' do
  if presence_valid?(params[:name], params[:message], params[:email], params[:phone], params[:location])
    @full_name = "#{params[:name].capitalize}"
    @phone = params[:phone]
    @email = params[:email]
    @message = params[:message]
    @location = params[:location]

    send_mail(@full_name, @email, @phone, @message, @location)
    redirect '/started?mail=true'
  else
    puts 'Email error: blank fields'
    redirect '/started'
  end

end

get '/privacy' do
  erb :privacy, layout: :application
end


# Staff Bio pages
get '/about/megan' do
  erb :"about/megan", layout: :application
end

get '/about/alexandra' do
  erb :"about/alexandra", layout: :application
end

get '/about/elizabeth' do
  erb :"about/elizabeth", layout: :application
end

get '/about/allison' do
  erb :"about/allison", layout: :application
end

get '/about/heather' do
  erb :"about/heather", layout: :application
end

get '/about/suzie' do
  erb :"about/suzie", layout: :application
end

get '/about/briana' do
  erb :"about/briana", layout: :application
end

get '/about/erika' do
  erb :"about/erika", layout: :application
end

get '/about/annemarie' do
  erb :"about/annemarie", layout: :application
end

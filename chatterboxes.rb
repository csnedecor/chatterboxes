require 'sinatra'

get '/' do
  erb :home, layout: :application
end

get '/home' do
  erb :home, layout: :application
end

get '/about' do
  erb :about, layout: :application
end

get '/contact' do
  erb :contact, layout: :application
end

get 'services' do
  erb :services, layout: :application
end

get '/started' do
  erb :started, layout: :application
end


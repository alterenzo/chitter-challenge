ENV['RACK_ENV'] ||= "development"

require 'sinatra/base'
require 'sinatra/partial'

require_relative './data_mapper_setup'


class Chitter < Sinatra::Base

  get '/' do
    redirect '/users/new'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.new(name: params[:name],
            email: params[:email],
            username: params[:username],
            password: params[:password],
            password_confirmation: params[:password_confirmation])
    if user.save
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/users/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end

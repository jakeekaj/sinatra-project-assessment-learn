require './config/environment'
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'


class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "drowssap"
    register Sinatra::Flash
    register Sinatra::RedirectWithFlash
  end

 get "/" do
 	if logged_in?
      redirect "/home" 
    else
    erb :index
    end
  end

  get "/signup" do
  	if logged_in?
      redirect "/home"
    else
      erb :signup
    end
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      redirect "/signup"
      else
      user = User.create(username: params[:username], email: params[:email], password: params[:password] )
      session[:user_id] = user.id
      redirect "/home"
    end
  end


  get "/login" do
  	if logged_in?
      redirect "/home"
    else
      erb :login
    end
  end

  post "/login" do
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
     else
      user = User.find_by(username: params[:username] )
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/home"
        else
        redirect "/failure"
      end
    end
  end


  get "/failure" do
    erb :failure
  end

  get "/logout" do
  	if !logged_in?
      redirect "/"
    else
    session.clear
    redirect "/login"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'/users/show'
  end

  get '/home' do
    if !logged_in?
      redirect "/login"
    else
    @user = current_user
    erb :'home'
   end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
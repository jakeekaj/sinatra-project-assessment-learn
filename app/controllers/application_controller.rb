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
  @title = "Welcome to JMDB"
 	if logged_in?
      redirect "/home" 
    else
    erb :index
    end
  end

  get "/signup" do
    @title = "Signup at JMDB"
  	if logged_in?
      redirect "/home"
    else
      @notice = session[:notice]
      session[:notice] = nil
      erb :signup
    end
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      session[:notice] = "Please fill in all fields and try again."
      redirect "/signup"
      else
      user = User.create(username: params[:username], email: params[:email], password: params[:password] )
      session[:user_id] = user.id
      redirect "/home"
    end
  end


  get "/login" do
    @title = "Login to your JMDB Account"
  	if logged_in?
      redirect "/home"
    else
      @notice = session[:notice]
      session[:notice] = nil
      erb :login
    end
  end

  post "/login" do
    if params[:username] == "" || params[:password] == ""
      session[:notice] = "Please fill in all fields and try again."
      redirect "/login"
     else
      user = User.find_by(username: params[:username] )
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/home"
        else
        session[:notice] = "Invalid username or password. Please try again."
        redirect "/login"
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
    @title = "JMDB HOMEPAGE"
    if !logged_in?
      redirect "/login"
    else
    @user = current_user
    erb :'home'
   end
  end

  helpers do
    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end

end
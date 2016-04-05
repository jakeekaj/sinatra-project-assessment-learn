require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "78y482eh2o"
  end

 get "/" do
 	if logged_in?
      redirect "/tweets"
    else
    erb :index
    end
  end

  get "/signup" do
  	if logged_in?
      redirect "/tweets"
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
      redirect "/tweets"
    end
  end


  get "/login" do
  	if logged_in?
      redirect "/tweets"
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
        redirect "/tweets"
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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
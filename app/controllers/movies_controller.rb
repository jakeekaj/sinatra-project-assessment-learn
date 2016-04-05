class TweetsController < ApplicationController


  get '/tweets' do
    if !logged_in?
      redirect "/login"
    else
    @user = current_user
    @users = User.all
    @tweets = Tweet.all
    erb :'tweets/index'
   end
  end


  get '/tweets/new' do
    if !logged_in?
      redirect "/login"
    else
    erb :'tweets/new'
    end
  end

  post '/tweets' do
    if params[:content] == "" 
      redirect '/tweets/new'
    else
    @tweet = Tweet.create(content: params[:content], user_id: current_user.id)
    redirect '/tweets/' + @tweet.id.to_s
    end  
  end



  get '/tweets/:id' do
    if !logged_in?
      redirect "/login"
    else
    @tweet = Tweet.find(params[:id])
    erb :'tweets/show'
    end
  end

  get '/tweets/:id/edit' do
    if !logged_in?
      redirect "/login"
    else
    @tweet = Tweet.find(params[:id])
      if current_user.tweets.include?(@tweet)
        if @tweet == nil
          redirect "/tweets"
        else
          erb :'tweets/edit'
        end
      else
        redirect '/tweets'
      end
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if params[:content] == "" 
      redirect '/tweets/' + @tweet.id.to_s + '/edit'
    else
    @tweet.content = params[:content]
    @tweet.save
    redirect '/tweets/' + @tweet.id.to_s
    end
  end

  delete '/tweets/:id/delete' do
    if current_user.tweets.include?(Tweet.find(params[:id]))
    Tweet.find(params[:id]).destroy
    redirect '/tweets'
    else
    redirect '/tweets'
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
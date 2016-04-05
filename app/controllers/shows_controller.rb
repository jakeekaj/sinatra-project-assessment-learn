class ShowsController < ApplicationController


  get '/shows' do
    if !logged_in?
      redirect "/login"
    else
    @user = current_user
    @users = User.all
    @shows = Show.all
    erb :'shows/index'
   end
  end


  get '/shows/new' do
    if !logged_in?
      redirect "/login"
    else
    erb :'shows/new'
    end
  end

  post '/shows' do
    if params[:content] == "" 
      redirect '/shows/new'
    else
    @show = Show.create(content: params[:content], user_id: current_user.id)
    redirect '/shows/' + @show.id.to_s
    end  
  end



  get '/shows/:id' do
    if !logged_in?
      redirect "/login"
    else
    @show = Show.find(params[:id])
    erb :'shows/show'
    end
  end

  get '/shows/:id/edit' do
    if !logged_in?
      redirect "/login"
    else
    @show = Show.find(params[:id])
      if current_user.shows.include?(@show)
        if @show == nil
          redirect "/shows"
        else
          erb :'shows/edit'
        end
      else
        redirect '/shows'
      end
    end
  end

  patch '/shows/:id' do
    @show = Show.find(params[:id])
    if params[:content] == "" 
      redirect '/shows/' + @show.id.to_s + '/edit'
    else
    @show.content = params[:content]
    @show.save
    redirect '/shows/' + @show.id.to_s
    end
  end

  delete '/shows/:id/delete' do
    if current_user.shows.include?(Show.find(params[:id]))
    Show.find(params[:id]).destroy
    redirect '/shows'
    else
    redirect '/shows'
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
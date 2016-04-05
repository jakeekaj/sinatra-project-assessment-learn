class MoviesController < ApplicationController


  get '/movies' do
    if !logged_in?
      redirect "/login"
    else
    @user = current_user
    @users = User.all
    @movies = Movie.all
    erb :'movies/index'
   end
  end


  get '/movies/new' do
    if !logged_in?
      redirect "/login"
    else
    erb :'movies/new'
    end
  end

  post '/movies' do
    if params[:content] == "" 
      redirect '/movies/new'
    else
    @movie = Movie.create(content: params[:content], user_id: current_user.id)
    redirect '/movies/' + @movie.id.to_s
    end  
  end



  get '/movies/:id' do
    if !logged_in?
      redirect "/login"
    else
    @movie = Movie.find(params[:id])
    erb :'movies/show'
    end
  end

  get '/movies/:id/edit' do
    if !logged_in?
      redirect "/login"
    else
    @movie = Movie.find(params[:id])
      if current_user.movies.include?(@movie)
        if @movie == nil
          redirect "/movies"
        else
          erb :'movies/edit'
        end
      else
        redirect '/movies'
      end
    end
  end

  patch '/movies/:id' do
    @movie = Movie.find(params[:id])
    if params[:content] == "" 
      redirect '/movies/' + @movie.id.to_s + '/edit'
    else
    @movie.content = params[:content]
    @movie.save
    redirect '/movies/' + @movie.id.to_s
    end
  end

  delete '/movies/:id/delete' do
    if current_user.movies.include?(Movie.find(params[:id]))
    Movie.find(params[:id]).destroy
    redirect '/movies'
    else
    redirect '/movies'
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
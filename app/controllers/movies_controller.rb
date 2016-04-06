class MoviesController < ApplicationController


  get '/movies' do
    if !logged_in?
      redirect "/login"
    else
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
    if params[:title] == "" 
      #flash[:error] = "Please enter a Title"
      redirect '/movies/new'
    else
    @movie = Movie.create(title: params[:title],year: params[:year], user_id: current_user.id)
    ##Handle actors
    if params[:actor1] != ""
    a = Actor.create(name: params[:actor1], user_id: current_user.id)
    @movie.actors << a
    end
    if params[:actor2] != ""
    b = Actor.create(name: params[:actor2], user_id: current_user.id)
    @movie.actors << b
    end
    params[:actors].each do |actor|
      c = Actor.find(actor)
      @movie.actors << c
    end
    ##Handle genres
    if params[:genre1] != ""
    d = Genre.create(name: params[:genre1], user_id: current_user.id)
    @movie.genres << d
    end
    if params[:genre2] != ""
    e = Genre.create(name: params[:genre2], user_id: current_user.id)
    @movie.genres << e
    end
    params[:genres].each do |genre|
      f = Genre.find(genre)
      @movie.genres << f
    end

    @movie.save
    redirect '/movies/' + @movie.slug
    end  
  end



  get '/movies/:slug' do
    if !logged_in?
      redirect "/login"
    else
    @movie = Movie.find_by_slug(params[:slug])
    erb :'movies/show'
    end
  end

  get '/movies/:slug/edit' do
    if !logged_in?
      redirect "/login"
    else
    @movie = Movie.find_by_slug(params[:slug])
    if @movie == nil
      #flash[:error] = "Movie does not exist"
      redirect "/movies"
      else
      if current_user.movies.include?(@movie)
          erb :'movies/edit'
        else
        #flash[:error] = "You are not authorized to edit this movie."
        redirect '/movies/' + @movie.slug
      end
      end
    end
  end

  patch '/movies/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    if params[:title] == "" 
      #flash[:error] = "Please enter a Title"
      redirect '/movies/' + @movie.slug + '/edit'
    else
    @movie.title = params[:title]
    @movie.year = params[:year]
    if params[:actor1] != ""
    a = Actor.create(name: params[:actor1], user_id: current_user.id)
    @movie.actors << a
    end
    if params[:actor2] != ""
    b = Actor.create(name: params[:actor2], user_id: current_user.id)
    @movie.actors << b
    end
    if params[:genre1] != ""
    d = Genre.create(name: params[:genre1], user_id: current_user.id)
    @movie.genres << d
    end
    if params[:genre2] != ""
    e = Genre.create(name: params[:genre2], user_id: current_user.id)
    @movie.genres << e
    end
    params[:movie][:actor_ids].each do |actor|
      j = Actor.find(actor)
      @movie.actors << j
    end

    params[:movie][:genre_ids].each do |genre|
      x = Genre.find(genre)
      @movie.genres << x
    end
    @movie.save
    redirect '/movies/' + @movie.slug
    end
  end

  delete '/movies/:slug/delete' do
    if current_user.movies.include?(Movie.find_by_slug(params[:slug]))
    Movie.find_by_slug(params[:slug]).destroy
    redirect '/movies'
    else
    #flash[:error] = "You are not authorized to delete this movie."
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
class MoviesController < ApplicationController


  get '/movies' do
    if !logged_in?
      redirect "/login"
    else
    @title = "Movie List - JMDB"  
    @movies = Movie.all
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'movies/index'
   end
  end


  get '/movies/new' do
    if !logged_in?
      redirect "/login"
    else
    @title = "Add a new movie - JMDB"   
    @notice = session[:notice]
    session[:notice] = nil
    erb :'movies/new'
    end
  end

  post '/movies' do
    @movie = Movie.new(title: params[:title],year: params[:year], user_id: current_user.id)
    ##Handle actors
    if params[:actor1] != ""
    a = Actor.new(name: params[:actor1], user_id: current_user.id)
    @movie.actors << a
    end
    if params[:actor2] != ""
    b = Actor.new(name: params[:actor2], user_id: current_user.id)
    @movie.actors << b
    end
    if params[:actors]
      params[:actors].each do |actor|
      c = Actor.find(actor)
      @movie.actors << c
      end
    end
    ##Handle genres
    if params[:genre1] != ""
    d = Genre.new(name: params[:genre1], user_id: current_user.id)
    @movie.genres << d
    end
    if params[:genre2] != ""
    e = Genre.new(name: params[:genre2], user_id: current_user.id)
    @movie.genres << e
    end
    if params[:genres]
      params[:genres].each do |genre|
      f = Genre.find(genre)
      @movie.genres << f
      end
    end

    if @movie.save
    session[:notice] = "Movie successfully saved!"
    redirect '/movies/' + @movie.slug
    else
    session[:notice] = "Movie not saved! Please fill * required fields."
    redirect '/movies/new'
    end

  end



  get '/movies/:slug' do
    if !logged_in?
      redirect "/login"
    else
    @movie = Movie.find_by_slug(params[:slug])
    @title = @movie.title.to_s + " " + @movie.year.to_s + " - JMDB"
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'movies/show'
    end
  end

  get '/movies/:slug/edit' do
    if !logged_in?
      redirect "/login"
    else
    @error = session[:error]
    session[:notice] = nil
    @movie = Movie.find_by_slug(params[:slug])
    @title = "Edit " + @movie.title.to_s + " " + @movie.year.to_s + " - JMDB"  
    if @movie == nil
      session[:error] = "Movie does not exist"
      redirect "/movies"
      else
      if current_user.movies.include?(@movie)
          erb :'movies/edit'
        else
        session[:error] = "You are not authorized to edit this movie."
        redirect '/movies/' + @movie.slug
      end
      end
    end
  end

  patch '/movies/:slug' do
    @movie = Movie.find_by_slug(params[:slug])
    if params[:title] == "" 
      session[:error] = "Please enter a Title"
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
    @movie.actors.delete_all
    if params[:movie][:actor_ids]
      params[:movie][:actor_ids].each do |actor|
      j = Actor.find(actor)
      @movie.actors << j
      end
    end
    @movie.genres.delete_all
    if params[:movie][:genre_ids]
      params[:movie][:genre_ids].each do |genre|
      x = Genre.find(genre)
      @movie.genres << x
      end
    end
    @movie.save
    redirect '/movies/' + @movie.slug
    end
  end

  delete '/movies/:slug/delete' do
    if current_user.movies.include?(Movie.find_by_slug(params[:slug]))
    Movie.find_by_slug(params[:slug]).destroy
    session[:notice] = "Movie deleted!"
    redirect '/movies'
    else
    session[:error] = "You are not authorized to delete that movie!"
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
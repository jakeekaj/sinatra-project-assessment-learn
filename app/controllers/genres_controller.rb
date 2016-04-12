class GenresController < ApplicationController


  get '/genres' do
    if !logged_in?
      redirect "/login"
    else
    @title = "Genre List - JMDB"  
    @genres = Genre.all
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'genres/index'
   end
  end


  get '/genres/new' do
    if !logged_in?
      redirect "/login"
    else
    @title = "Add a new genre - JMDB"   
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'genres/new'
    end
  end

  post '/genres' do
    @genre = Genre.new(name: params[:name], user_id: current_user.id)
    ##Handle movies
    if params[:movie][:title] != "" && params[:movie][:year] == "" 
      session[:error] = "Genre was not saved. Movie cannot be added - Year is missing"
      redirect '/actors/new'
    end
    if params[:movie][:title] == "" && params[:movie][:year] != "" 
      session[:error] = "Genre was not saved. Movie cannot be added - Title is missing"
      redirect '/actors/new'
    end
    if params[:movie][:title] != "" && params[:movie][:year] != ""
    m = Movie.new(title: params[:movie][:title],year: params[:movie][:year], user_id: current_user.id)
    @genre.movies << m
    end
    if params[:movies]
      params[:movies].each do |movie|
      c = Movie.find(movie)
      @genre.movies << c
      end
    end
    ##Handle tv shows
    if params[:show][:title] != "" && params[:show][:year] == "" 
      session[:error] = "Genre was not saved. Show cannot be added - Year is missing"
      redirect '/actors/new'
    end
    if params[:show][:title] == "" && params[:show][:year] != "" 
      session[:error] = "Genre was not saved. Show cannot be added - Title is missing"
      redirect '/actors/new'
    end
    if params[:show][:title] != "" && params[:show][:year] != ""
    x = Show.new(title: params[:show][:title],year: params[:show][:year], user_id: current_user.id)
    @genre.shows << x
    end
    if params[:shows]
      params[:shows].each do |show|
      y = Show.find(show)
      @genre.shows << y
      end
    end

    ##Handle actors
    if params[:actor] != ""
    d = Actor.new(name: params[:actor], user_id: current_user.id)
    @genre.actors << d
    end
    if params[:actors]
      params[:actors].each do |actor|
      f = Actor.find(actor)
      @genre.actors << f
      end
    end

    if @genre.save
    session[:notice] = "Genre successfully saved!"
    redirect '/genres/' + @genre.slug
    else
    session[:error] = "Genre not saved! Please recheck fields."
    redirect '/genres/new'
    end

  end



  get '/genres/:slug' do
    if !logged_in?
      redirect "/login"
    else
    @genre = Genre.find_by_slug(params[:slug])
    if @genre == nil
      session[:error] = "Genre does not exist"
      redirect "/genres"
      end
    @title = @genre.name.to_s + " - JMDB"
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'genres/show'
    end
  end

  get '/genres/:slug/edit' do
    if !logged_in?
      redirect "/login"
    else
    @error = session[:error]
    session[:error] = nil
    @genre = Genre.find_by_slug(params[:slug])
    if @genre == nil
      session[:error] = "Genre does not exist"
      redirect "/genres"
      else
      @title = "Edit " + @genre.name.to_s + " - JMDB"  
      if current_user.genres.include?(@genre)
          erb :'genres/edit'
        else
        session[:error] = "You are not authorized to edit this genre."
        redirect '/genres/' + @genre.slug
      end
      end
    end
  end

  patch '/genres/:slug' do
    @genre = Genre.find_by_slug(params[:slug])
    if params[:name] == "" 
      session[:error] = "Please enter name!"
      redirect '/genres/' + @genre.slug + '/edit'
    else
    @genre.name = params[:name]
    @genre.movies.delete_all
    if params[:movies]
      params[:movies].each do |movie|
      c = Movie.find(movie)
      @genre.movies << c
      end
    end
    @genre.shows.delete_all
    if params[:shows]
      params[:shows].each do |show|
      f = Show.find(show)
      @genre.shows << f
      end
    end
    @genre.actors.delete_all
    if params[:actors]
      params[:actors].each do |actor|
      f = Actor.find(actor)
      @genre.actors << f
      end
    end
    ##Handle new movie addition
    if params[:movie][:title] != ""
      a = Movie.create(title: params[:movie][:title],year: params[:movie][:year], user_id: current_user.id)
      @genre.movies << a
    end
    ##Handle new show addition
    if params[:show][:title] != ""
      d = Show.create(title: params[:show][:title],year: params[:show][:year], user_id: current_user.id)
      @genre.shows << d
    end
    ##Handle new actor addition
    if params[:actor] != ""
      e = Actor.create(name: params[:actor], user_id: current_user.id)
      @genre.actors << e
    end
    if @genre.save
    session[:notice] = "Genre successfully edited!"
    redirect '/genres/' + @genre.slug
    else
    session[:error] = "Genre not edited! Please recheck fields."
    redirect '/genres/' + @genre.slug + '/edit'
    end
    end
  end

  delete '/genres/:slug/delete' do
    if current_user.genres.include?(Genre.find_by_slug(params[:slug]))
    Genre.find_by_slug(params[:slug]).destroy
    session[:notice] = "Genre deleted!"
    redirect '/genres'
    else
    session[:error] = "You are not authorized to delete that genre!"
    redirect '/genres'
    end
  end


end
class ActorsController < ApplicationController


  get '/actors' do
    if !logged_in?
      redirect "/login"
    else
    @title = "Actor List - JMDB"  
    @actors = Actor.all
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'actors/index'
   end
  end


  get '/actors/new' do
    if !logged_in?
      redirect "/login"
    else
    @title = "Add a new actor - JMDB"   
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'actors/new'
    end
  end

  post '/actors' do
    @actor = Actor.new(name: params[:name], user_id: current_user.id)
    ##Handle movies
    if params[:movie][:title] != "" && params[:movie][:year] != ""
    m = Movie.new(title: params[:movie][:title],year: params[:movie][:year], user_id: current_user.id)
    @actor.movies << m
    end
    if params[:movies]
      params[:movies].each do |movie|
      c = Movie.find(movie)
      @actor.movies << c
      end
    end
    ##Handle tv shows
    if params[:show][:title] != "" && params[:show][:year] != ""
    x = Show.new(title: params[:show][:title],year: params[:show][:year], user_id: current_user.id)
    @actor.shows << x
    end
    if params[:shows]
      params[:shows].each do |show|
      y = Show.find(show)
      @actor.shows << y
      end
    end

    ##Handle genres
    if params[:genre] != ""
    d = Genre.new(name: params[:genre], user_id: current_user.id)
    @actor.genres << d
    end
    if params[:genres]
      params[:genres].each do |genre|
      f = Genre.find(genre)
      @actor.genres << f
      end
    end

    if @actor.save
    session[:notice] = "Actor successfully saved!"
    redirect '/actors/' + @actor.slug
    else
    session[:error] = "Actor not saved! Please fill * required fields."
    redirect '/actors/new'
    end

  end



  get '/actors/:slug' do
    if !logged_in?
      redirect "/login"
    else
    @actor = Actor.find_by_slug(params[:slug])
    if @actor == nil
      session[:error] = "Actor does not exist"
      redirect "/actors"
      end
    @title = @actor.name.to_s + " - JMDB"
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'actors/show'
    end
  end

  get '/actors/:slug/edit' do
    if !logged_in?
      redirect "/login"
    else
    @error = session[:error]
    session[:error] = nil
    @actor = Actor.find_by_slug(params[:slug])
    if @actor == nil
      session[:error] = "Actor does not exist"
      redirect "/actors"
      else
      @title = "Edit " + @actor.title.to_s + " " + @actor.year.to_s + " - JMDB"  
      if current_user.actors.include?(@actor)
          erb :'actors/edit'
        else
        session[:error] = "You are not authorized to edit this actor."
        redirect '/actors/' + @actor.slug
      end
      end
    end
  end

  patch '/actors/:slug' do
    @actor = Actor.find_by_slug(params[:slug])
    if params[:title] == "" || params[:year] == ""
      session[:error] = "Please enter both Title and Year!"
      redirect '/actors/' + @actor.slug + '/edit'
    else
    @actor.title = params[:title]
    @actor.year = params[:year]
    if params[:actor1] != ""
      a = Actor.create(name: params[:actor1], user_id: current_user.id)
      @actor.actors << a
    end
    if params[:actor2] != ""
      b = Actor.create(name: params[:actor2], user_id: current_user.id)
      @actor.actors << b
    end
    if params[:genre1] != ""
      d = Genre.create(name: params[:genre1], user_id: current_user.id)
      @actor.genres << d
    end
    if params[:genre2] != ""
      e = Genre.create(name: params[:genre2], user_id: current_user.id)
      @actor.genres << e
    end
    @actor.actors.delete_all
    if params[:actor][:actor_ids]
      params[:actor][:actor_ids].each do |actor|
      j = Actor.find(actor)
      @actor.actors << j
      end
    end
    @actor.genres.delete_all
    if params[:actor][:genre_ids]
      params[:actor][:genre_ids].each do |genre|
      x = Genre.find(genre)
      @actor.genres << x
      end
    end
    if @actor.save
    session[:notice] = "Actor successfully edited!"
    redirect '/actors/' + @actor.slug
    else
    session[:error] = "Actor not edited! Please fill * required fields."
    redirect '/actors/' + @actor.slug + '/edit'
    end
    end
  end

  delete '/actors/:slug/delete' do
    if current_user.actors.include?(Actor.find_by_slug(params[:slug]))
    Actor.find_by_slug(params[:slug]).destroy
    session[:notice] = "Actor deleted!"
    redirect '/actors'
    else
    session[:error] = "You are not authorized to delete that actor!"
    redirect '/actors'
    end
  end


end
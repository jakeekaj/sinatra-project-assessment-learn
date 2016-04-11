class ShowsController < ApplicationController


  get '/shows' do
    if !logged_in?
      redirect "/login"
    else
    @shows = Show.all
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:error] = nil
    erb :'shows/index'
   end
  end


  get '/shows/new' do
    if !logged_in?
      redirect "/login"
    else
    @notice = session[:notice]
    session[:notice] = nil
    erb :'shows/new'
    end
  end

  post '/shows' do
    @show = Show.new(title: params[:title],year: params[:year], user_id: current_user.id)
    ##Handle actors
    if params[:actor1] != ""
    a = Actor.new(name: params[:actor1], user_id: current_user.id)
    @show.actors << a
    end
    if params[:actor2] != ""
    b = Actor.new(name: params[:actor2], user_id: current_user.id)
    @show.actors << b
    end
    if params[:actors]
      params[:actors].each do |actor|
      c = Actor.find(actor)
      @show.actors << c
      end
    end
    ##Handle genres
    if params[:genre1] != ""
    d = Genre.new(name: params[:genre1], user_id: current_user.id)
    @show.genres << d
    end
    if params[:genre2] != ""
    e = Genre.new(name: params[:genre2], user_id: current_user.id)
    @show.genres << e
    end
    if params[:genres]
      params[:genres].each do |genre|
      f = Genre.find(genre)
      @show.genres << f
      end
    end

    if @show.save
    session[:notice] = "Show successfully saved!"
    redirect '/shows/' + @show.slug
    else
    session[:notice] = "Show not saved! Please fill * required fields."
    redirect '/shows/new'
    end

  end



  get '/shows/:slug' do
    if !logged_in?
      redirect "/login"
    else
    @show = Show.find_by_slug(params[:slug])
    @notice = session[:notice]
    session[:notice] = nil
    @error = session[:error]
    session[:notice] = nil
    erb :'shows/show'
    end
  end

  get '/shows/:slug/edit' do
    if !logged_in?
      redirect "/login"
    else
    @error = session[:error]
    session[:notice] = nil
    @show = Show.find_by_slug(params[:slug])
    if @show == nil
      session[:error] = "Show does not exist"
      redirect "/shows"
      else
      if current_user.shows.include?(@show)
          erb :'shows/edit'
        else
        session[:error] = "You are not authorized to edit this show."
        redirect '/shows/' + @show.slug
      end
      end
    end
  end

  patch '/shows/:slug' do
    @show = Show.find_by_slug(params[:slug])
    if params[:title] == "" 
      session[:error] = "Please enter a Title"
      redirect '/shows/' + @show.slug + '/edit'
    else
    @show.title = params[:title]
    @show.year = params[:year]
    if params[:actor1] != ""
      a = Actor.create(name: params[:actor1], user_id: current_user.id)
      @show.actors << a
    end
    if params[:actor2] != ""
      b = Actor.create(name: params[:actor2], user_id: current_user.id)
      @show.actors << b
    end
    if params[:genre1] != ""
      d = Genre.create(name: params[:genre1], user_id: current_user.id)
      @show.genres << d
    end
    if params[:genre2] != ""
      e = Genre.create(name: params[:genre2], user_id: current_user.id)
      @show.genres << e
    end
    if params[:show][:actor_ids]
      params[:show][:actor_ids].each do |actor|
      j = Actor.find(actor)
      @show.actors << j
      end
    end
    if params[:show][:genre_ids]
      params[:show][:genre_ids].each do |genre|
      x = Genre.find(genre)
      @show.genres << x
      end
    end
    @show.save
    redirect '/shows/' + @show.slug
    end
  end

  delete '/shows/:slug/delete' do
    if current_user.shows.include?(Show.find_by_slug(params[:slug]))
    Show.find_by_slug(params[:slug]).destroy
    session[:notice] = "Show deleted!"
    redirect '/shows'
    else
    session[:error] = "You are not authorized to delete that show!"
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
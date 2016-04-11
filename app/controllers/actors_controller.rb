class ActorsController < ApplicationController


  get '/actors' do
    if !logged_in?
      redirect "/login"
    else
    @user = current_user
    @users = User.all
    @actors = Actor.all
    erb :'actors/index'
   end
  end


  get '/actors/new' do
    if !logged_in?
      redirect "/login"
    else
    erb :'actors/new'
    end
  end

  post '/actors' do
    if params[:content] == "" 
      redirect '/actors/new'
    else
    @actor = Actor.create(content: params[:content], user_id: current_user.id)
    redirect '/actors/' + @actor.id.to_s
    end  
  end



  get '/actors/:id' do
    if !logged_in?
      redirect "/login"
    else
    @actor = Actor.find(params[:id])
    erb :'actors/show'
    end
  end

  get '/actors/:id/edit' do
    if !logged_in?
      redirect "/login"
    else
    @actor = Actor.find(params[:id])
      if current_user.actors.include?(@actor)
        if @actor == nil
          redirect "/actors"
        else
          erb :'actors/edit'
        end
      else
        redirect '/actors'
      end
    end
  end

  patch '/actors/:id' do
    @actor = Actor.find(params[:id])
    if params[:content] == "" 
      redirect '/actors/' + @actor.id.to_s + '/edit'
    else
    @actor.content = params[:content]
    @actor.save
    redirect '/actors/' + @actor.id.to_s
    end
  end

  delete '/actors/:id/delete' do
    if current_user.actors.include?(Actor.find(params[:id]))
    Actor.find(params[:id]).destroy
    redirect '/actors'
    else
    redirect '/actors'
    end
  end



end
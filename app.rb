require 'rack/csrf'
require 'sinatra'
require 'sinatra/json'
require 'omniauth'
require 'omniauth-github'
require 'sinatra/activerecord'
require './models/user'
require './models/task_list'
require './models/item'

secrets = YAML.load_file('secrets.yml')

configure do
  set :sessions, true
  set :inline_templates, true
end

helpers do
  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def current_user
    User.find_by_id(session[:user_id])
  end
end

use OmniAuth::Builder do
  provider :github, secrets['github_key'], secrets['github_secret']
end

post '/add_item' do
  if current_user
    item = Item.create(
      value: params[:value],
      task_list_id: params[:task_list_id])
    json item: { value: item.value, id: item.id }
  else
    status 401
  end
end

delete '/items/:id' do
  item = Item.find(params[:id])
  if  item.destroy
    json item_id: params[:id]
  else 
    status 500
  end    
end

put '/items/:id' do
  item = Item.find(params[:id])
  if item.update(done: !item.done)
    json item: { done: item.done, id: item.id }
  else
    status 500
  end
end

get '/' do
  erb :index
end

get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  user = User.from_omniauth(auth)
  if user
    session[:user_id] = user.id
    redirect '/'
  else
    erb :session_fail
  end
end

get '/auth/failure' do
  erb :auth_fail
end

get '/logout' do
  session[:user_id] = nil
  redirect '/'
end

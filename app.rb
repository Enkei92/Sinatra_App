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
end

use OmniAuth::Builder do
  provider :github, secrets['github_key'], secrets['github_secret']
end

post '/add_item' do
  if session[:authenticated]
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
  item.destroy
  json item_id: params[:id]
end

put '/items/:id' do
  item = Item.find(params[:id])
  item.update(done: !item.done)
  json item: { done: item.done, id: item.id }
end

get '/' do
  if session[:authenticated]
    @user = User.find(session[:user_id])
    erb :index
  end  
end

get '/auth/:provider/callback' do
  auth = request.env['omniauth.auth']
  @user = User.from_omniauth(auth)
  if @user
    session[:user_id] = @user.id
    session[:user_name] = @user.name
    session[:authenticated] = true
    redirect '/'
  else
    erb "<h1>Can's create session</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
end

get '/auth/failure' do
  erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
end

get '/logout' do
  session[:authenticated] = false
  puts session[:authenticated]
  redirect '/'
end


require "rubygems"
require "sinatra"
require "httparty"
require 'open-uri'
require 'json'

  AUTH_SERVER = "https://hashblue.com"
  API_SERVER = "https://api.hashblue.com"
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  $access_token = ""
  $refresh = ""


  get '/auth' do
     redirect "https://hashblue.com/oauth/authorize?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&redirect_uri=http://" + request.host_with_port + "/callback"
  end

  get '/callback' do
    response = HTTParty.post(AUTH_SERVER + "/oauth/access_token", :body => {
      :client_id => CLIENT_ID,
      :client_secret => CLIENT_SECRET,
      :redirect_uri => "http://" + request.host_with_port + "/callback",
      :code => params["code"],
      :grant_type => 'authorization_code'})
      
      $access_token = response["access_token"]
      $refresh = response["refresh_token"]

       "<p>access token: #{$access_token} <br>
       refresh token: #{$refresh} </p>"

  end

  get '/refresh'
    response = HTTParty.post("https://hashblue.com/oauth/access_token?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&grant_type=refresh_token&refresh_token=#{$refresh_token}")
    unless response["access_token"] == nil || response["refresh_token"] == nil 
      $access_token = response["access_token"]
      $refresh_token =  response["refresh_token"]
      ENV['CLIENT_TOKEN']=$access_token
      ENV['REFRESH']=$refresh_token
    end
  end
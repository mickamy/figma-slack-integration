require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'

get '/' do
  'Hi, this is Bannai Tarao.<br/>High collar is beautiful.'
end

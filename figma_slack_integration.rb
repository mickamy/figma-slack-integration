require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load' if development?
require 'json'

Dir[File.join(__dir__, 'lib', '*.rb')].each do |file|
  require file
  also_reload file
end

helpers do
  def slack_client
    SlackClient.new(url: ENV['SLACK_WEBHOOK_URL'])
  end
end

get '/' do
  'Hi, this is Bannai Tarao.<br/>High collar is beautiful.'
end

post '/file/comment' do
  body = request.body.read
  hash = JSON.parse(body, symbolize_names: true)
  response = FigmaResponse::FileComment.new(hash)
  slack_client.post(response.markdown)
end

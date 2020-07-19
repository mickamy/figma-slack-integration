require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load' if development?
require 'json'

Dir[File.join(__dir__, 'lib', '*.rb')].each do |file|
  require file
  also_reload file if development?
end

helpers do
  def slack_client
    SlackClient.new(url: ENV['SLACK_WEBHOOK_URL'])
  end

  def protect!(passcode)
    forbid! unless passcode == ENV['PASSCODE']
  end

  def forbid!
    throw(:halt, [401, "Not Authorized\n"])
  end
end

get '/' do
  'Hi, this is Bannai Tarao.<br/>High collar is beautiful.'
end

post '/file/comment' do
  body = request.body.read
  hash = JSON.parse(body, symbolize_names: true)
  protect!(hash[:passcode])

  response = FigmaResponse::FileComment.new(hash)
  slack_client.post(response.markdown)
end

post '/debug/file/comment' do
  body = request.body.read
  hash = JSON.parse(body, symbolize_names: true)
  protect!(hash[:passcode])

  response = FigmaResponse::FileComment.new(hash)
  response.markdown
end

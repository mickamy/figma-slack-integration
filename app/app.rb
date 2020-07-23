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
    # do not return 401 to protect from brute force attack
    throw(:halt, 200)
  end

  def hash_body
    body = request.body.read
    JSON.parse(body, symbolize_names: true)
  end
end

get '/' do
  'Hi, this is Bannai Tarao.<br/>High collar is beautiful.'
end

post '/file/comment' do
  body = hash_body
  protect!(body[:passcode])

  comment = FigmaBody::FileComment.new(body)
  slack_client.post(message: comment.message, content: comment.content)
end

if development?
  post '/file/comment/debug' do
    body = hash_body
    protect!(body[:passcode])

    comment = FigmaBody::FileComment.new(body)
    { message: comment.message, content: comment.content }.to_json
  end
end

require 'sinatra'
require 'sinatra/reloader' if development?
require 'dotenv/load' if development?

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

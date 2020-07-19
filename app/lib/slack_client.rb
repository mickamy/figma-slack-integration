require 'faraday'
require 'json'

class SlackClient
  def initialize(url:)
    @url = url
  end

  def post(message:, content:)
    body = {
      type: 'sections',
      fields: [
        {
          type: 'mrkdwn',
          text: message,
        },
        {
          type: 'mrkdwn',
          text: content,
        }
      ]
     }.to_json
    res = client.post(url, body, content_type: 'application/json')
    [res.status, res.headers, res.body]
  end

  private

  attr_reader :url

  def client
    Faraday.new
  end
end

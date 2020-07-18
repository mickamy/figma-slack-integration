module FigmaResponse
  class FileComment
    attr_reader :comment_text,
                :comment_id,
                :file_key,
                :file_name,
                :mentions,
                :passcode,
                :triggered_by

    def initialize(hash)
      @comment_text = parse(comment: hash[:comment], mentions: hash[:mentions])
      @comment_id = hash[:comment_id]
      @file_key = hash[:file_key]
      @file_name = hash[:file_name]
      @passcode = hash[:passcode]
      @triggered_by = hash[:triggered_by][:handle]
    end

    def message
      "#{triggered_by} commented on #{file_name}"
    end

    def url
      "https://figma.com/file/#{file_key}?utm_content=file_comment##{comment_id}"
    end

    private

    def parse(comment:, mentions:)
      comment.map do |item|
        item[:text] || mentions.find { |mention| mention[:id] == item[:mention] }[:handle]
      end.join(' ')
    end
  end
end

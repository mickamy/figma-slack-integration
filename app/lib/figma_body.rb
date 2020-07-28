module FigmaBody
  class FileComment
    attr_reader :content_text,
                :id,
                :file_key,
                :file_name,
                :is_reply,
                :triggered_by

    def initialize(hash)
      @content_text = parse(comment: hash[:comment], mentions: hash[:mentions])
      @id = hash[:comment_id]
      @file_key = hash[:file_key]
      @file_name = hash[:file_name]
      @is_reply = !hash[:parent_id].empty?
      @triggered_by = hash[:triggered_by][:handle]
    end

    def message
      text = is_reply ? "#{triggered_by} replied to a comment on #{file_name}" : "#{triggered_by} commented on #{file_name}"
      text.gsub(file_name, "<#{url}|#{file_name}>")
    end

    def content
      "> #{content_text.gsub("\n", "\n> ")}"
    end

    private

    def parse(comment:, mentions:)
      comment.map do |item|
        item[:text] || mentions.find { |mention| mention[:id] == item[:mention] }[:handle] + ' '
      end.join
    end

    def url
      "https://figma.com/file/#{file_key}?utm_content=file_comment##{id}"
    end
  end
end

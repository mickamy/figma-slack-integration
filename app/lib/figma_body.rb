module FigmaBody
  class FileComment
    attr_reader :content_text,
                :id,
                :file_key,
                :file_name,
                :parent_id,
                :resolved_at,
                :triggered_by

    def initialize(hash)
      @content_text = parse(comment: hash[:comment], mentions: hash[:mentions])
      @id = hash[:comment_id]
      @file_key = hash[:file_key]
      @file_name = hash[:file_name]
      @parent_id = !hash[:parent_id]
      @triggered_by = hash[:triggered_by][:handle]
      @resolved_at = hash[:resolved_at]
    end

    def message
      text = ''
      if resolved?
        text = "#{triggered_by} resolved or replied to a comment on #{file_name}"
      else
        text = reply? ? "#{triggered_by} replied to a comment on #{file_name}" : "#{triggered_by} commented on #{file_name}"
      end
      text.gsub(file_name, "<#{url}|#{file_name}>")
    end

    def content
      "> #{content_text.gsub("\n", "\n> ")}"
    end

    private

    def reply?
      !parent_id.empty?
    end

    def resolved?
      !resolved_at.empty?
    end

    def parse(comment:, mentions:)
      comment.map do |item|
        text = item[:text]
        if text.nil?
          handle = mentions.find { |mention| mention[:id] == item[:mention] }[:handle]
          "@#{handle}"
        else
          text
        end
      end.join
    end

    def url
      "https://figma.com/file/#{file_key}?utm_content=file_comment##{id}"
    end
  end
end

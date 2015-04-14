module Kindle

  class Highlight

    attr_reader :id, :highlight, :asin, :title, :author, :note_id, :note

    def initialize(id, highlight, asin, title, author, note_id, note)
      @id, @highlight, @asin, @title, @author, @note_id, @note = id, highlight, asin, title, author, note_id, note
    end

  end

end

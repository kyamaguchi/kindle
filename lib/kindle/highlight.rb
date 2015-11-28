module Kindle

  class Highlight

    attr_reader :id, :highlight, :asin, :location, :title, :author, :last_annotated_on, :note_id, :note

    def initialize(id, highlight, asin, location, title, author, last_annotated_on, note_id, note)
      @id, @highlight, @asin, @location, @title, @author, @last_annotated_on, @note_id, @note = id, highlight, asin, location, title, author, last_annotated_on, note_id, note
    end

  end

end

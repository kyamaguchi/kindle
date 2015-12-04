module Kindle
  class Converter

    def self.encode(str)
      Base64.strict_encode64(str)
    end

    def self.decode(code)
      Base64.strict_decode64(code)
    end
  end
end

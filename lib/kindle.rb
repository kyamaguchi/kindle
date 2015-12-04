require 'byebug'
require 'dotenv'
Dotenv.load
require 'nokogiri'
require 'mechanize'
require_relative 'kindle/amazon_info'
require_relative 'kindle/converter'
require_relative 'kindle/highlight'
require_relative 'kindle/highlights_parser'

module Kindle

  class Highlights

    def initialize(options = {})
      @login = options[:convert] ? Kindle::Converter.decode(options[:login]) : options[:login]
      @password = options[:convert] ? Kindle::Converter.decode(options[:password]) : options[:password]
      raise "login or password is missing" unless @login || @password
    end

    def fetch_highlights
      HighlightsParser.new(login: @login, password: @password).get_highlights
    end

  end

end

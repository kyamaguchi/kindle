require 'bundler/setup'
Bundler.setup
require 'byebug'
require 'vcr'
require 'active_support/all'

require 'kindle'

Dir[File.join(File.dirname(__FILE__), "..", "spec", "support", "**/*.rb")].each {|f| require f}

RSpec.configure do |config|
end

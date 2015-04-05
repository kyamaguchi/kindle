require 'bundler/setup'
Bundler.setup
require 'byebug'
require 'vcr'
require 'active_support/all'

require 'kindle'

Dir[File.join(File.dirname(__FILE__), "..", "spec", "support", "**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.around(:each, :vcr) do |example|
    spec_name = example.metadata[:file_path].gsub('./spec/', '').gsub('_spec.rb', '')
    desc_name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    name = [spec_name, desc_name].join("/")

    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb

  config.default_cassette_options = { record: ENV.fetch('RECORD'){ :once }.to_sym }
end

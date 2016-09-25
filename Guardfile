# http://qiita.com/quattro_4/items/6d966d6d59eb7bb8ec08

require 'guard/plugin'
require 'json'
require 'uri'
require 'active_support/all'
require 'kconv'
require 'byebug'

module ::Guard
  class VcrReader < ::Guard::Plugin
    def run_all
      target_path = 'spec/fixtures/vcr_cassettes'
      puts "Converting all request/response data in #{target_path}."
      Dir.glob("#{target_path}/**/*\.yml").each do |path|
        generate_pretty_log_from_yml(path)
      end
    end

    def run_on_changes(paths)
      puts "Converting request/response data. #{paths.inspect}"
      paths.each do |path|
        next unless File.exists?(path)
        log_path = generate_pretty_log_from_yml(path)
        puts "Generated #{log_path}"
      end
    end

    private

      def generate_pretty_log_from_yml(path)
        record = YAML.load_file(path)
        log_path = path.gsub(/\.yml/, '.txt')
        File.open(log_path, 'w') do |f|
          record["http_interactions"].each do |interaction|
            request_method = interaction["request"]["method"]

            f.write('='*80+"\n")
            f.write('Request '+'-'*80+"\n")
            f.write(interaction["recorded_at"]+"\n")
            f.write("#{request_method.upcase} #{interaction["request"]["uri"]}"+"\n")
            f.write(arrange_body_string interaction["request"]["body"]["string"]) if request_method == 'post'
            f.write("\n")
            f.write('Response '+'-'*80+"\n")
            f.write(arrange_body_string interaction["response"]["body"]["string"])
            f.write("\n")
          end
        end
        log_path
      end

      def arrange_body_string(string)
        begin
          JSON.pretty_generate JSON.parse(string)
        rescue
          begin
            ActiveSupport::Gzip.decompress(string)
          rescue
            string
          end
        end
      end
  end
end

guard :vcr_reader do
  watch(%r{^spec/fixtures/vcr_cassettes/.+\.yml$})
end

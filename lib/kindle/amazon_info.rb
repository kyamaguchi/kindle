class AmazonInfo

  def self.domain
    ENV['KINDLE_DOMAIN'] || 'amazon.com'
  end

  def self.kindle_url(protocol = 'http')
    "#{protocol}://kindle.#{domain}"
  end

  def self.kindle_https_url
    kindle_url('https')
  end
end

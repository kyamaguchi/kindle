def credentials
  {
    login: ENV['AMAZON_USERNAME_CODE'],
    password: ENV['AMAZON_PASSWORD_CODE'],
    convert: true,
  }
end

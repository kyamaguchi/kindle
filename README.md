# Kindle Highlights Fetcher

This little application will fetch a list of all your highlights from your kindle ebooks.

## Installation

    git clone https://github.com/kyamaguchi/kindle

## Usage

    cd kindle
    cp .env.sample .env
    ./bin/convert_credentials
    vi .env
    ./bin/kindle

### Preserve Amazon username on your local machine

You can keep username and password on your local not to type everytime.
You can set `AMAZON_USERNAME` in _.env_.
You could also set `AMAZON_PASSWORD`.

[Recommended] Or you can convert them to protect them against shoulder surfing.
Run `./bin/convert_credentials` and paste the output to _env_.
(`AMAZON_USERNAME_CODE` and `AMAZON_PASSWORD_CODE`)

You can change the salt with `AMAZON_CODE_SALT` if you like.

### Fetch highlights of different domain

Add `KINDLE_DOMAIN=amazon.co.jp` to _.env_ (Example: Japanese site)

### Limit the count of fetching

Fetching all your highlights could take time. You can limit the count of fetching.

Add `FETCH_COUNT_LIMIT=5` to _.env_

### Questions for device control on login

You could get questions for device control on login.
You will be asked phone number or zip code. (There might be other cases though.)

In that case, you can answer on command line interactively.
Or you can set `PHONE_NUMBER=09012345678` or `ZIP_CODE=1234567` in advance.

### User agent

You can change user agent alias with `USER_AGENT_ALIAS='Windows IE 9'`.
You can find available alias with `Mechanize::AGENT_ALIASES`.

Or

You can totally customize user agent with `USER_AGENT`.
Set the value like `Mozilla/5.0 (Macintosh; ...`.
You can find yours in http://whatsmyuseragent.com/

## Troubleshooting

If there are some problems on login, please login manually.
You could also think about changing user agent.

## Test

There are some test.
But some test aren't reproducible. (e.g. Device control on login)
These test should be run with line number when they are available.
`rspec spec/special_spec.rb:123`

You should never upload `spec/fixtures/vcr_cassettes/` to public because it includes credentials to login.
You could keep changes of cassettes on your local(preivate) branch if you want.
BUT NEVER EXPOSE THEM.

TODO:

- Answer security question with zip code
- Answer image recognition after failing login many times

## Other usage and license

MIT

© 2012 Matt Petty
[@lodestone](http://about.me/lodestone)

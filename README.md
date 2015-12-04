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

### User agent

You can change user agent alias with `USER_AGENT_ALIAS='Windows IE 9'`.
You can find available alias with `Mechanize::AGENT_ALIASES`.

## Other usage and license

MIT

© 2012 Matt Petty
[@lodestone](http://about.me/lodestone)

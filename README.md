# Kindle Highlights Fetcher

This little application will fetch a list of all your highlights from your kindle ebooks.

## Installation

    gem install kindle

## Usage

    kindle # Will prompt you for your login info. Don't worry it isn't stored.

### Preserve Amazon username on your local machine

    cp .env.sample .env

And then, change your username `AMAZON_USERNAME` in _.env_

You could also set `AMAZON_PASSWORD`.

### Fetch highlights of different domain

Add `KINDLE_DOMAIN=amazon.co.jp` to _.env_ (Example: Japanese site)

### Limit the count of fetching

Fetching all your highlights could take time. You can limit the count of fetching.

Add `FETCH_COUNT_LIMIT=5` to _.env_

### User agent

You can change user agent alias with `USER_AGENT_ALIAS='Windows IE 9'`.
You can find available alias with `Mechanize::AGENT_ALIASES`.

## Other usage and license

Hastily thrown together but incredibly useful since Amazon does not provide an API for kindle highlights. Please use this however you would like. This is licensed under MIT license.


© 2012 Matt Petty
[@lodestone](http://about.me/lodestone)

# README

# DEVELOPMENT GUIDE

## REPL

Since `Gemfile` has the line below, you just run `require "giri"` in `bundle exec irb` to start `Giri`.

```
gem "giri", path: './'
```

```
bundle install
```

```
bundle exec irb

# (irb):> require "giri"
```

## Local Build

Since it has `Rakefile`, you just run the following command to make build and install it on your local.

```
bundle exec rake build
bundle exec rake install
```

Then you just run `require "giri"` in `irb` to start `Giri`.

```
irb

(irb):> require "giri"
```

## Publish Gem

If you have the right to publish it to rubygems, run it.

```
bundle exec rake build
gem push ./pkg/giri-${VERSION}.gem
```

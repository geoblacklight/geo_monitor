# GeoMonitor
A Rails engine for monitoring geospatial web services.

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'geo_monitor'
```

And then execute:
```bash
bundle
```

Or install it yourself as:
```bash
gem install geo_monitor
```

## Developing
Set up the internal test app using `engine_cart`:
```bash
rake engine_cart:generate
```

Run the test suite, including RuboCop style checks:
```bash
rake ci
```

## License
The gem is available as open source under the terms of the [Apache License 2.0](https://opensource.org/licenses/Apache-2.0).

# Objcthin

this script can find unused selector and class for you project.app or LinkMap file.

这个脚本可以自动的帮你找出当前项目中不在使用的selector和class，支持debug版本的APP包和LinkMap文件。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'objcthin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install objcthin

## Usage

find unused selector:
    
    $ objcthin findsel apppath(the execuse app path)
    
find unused class:
      
    $ objcthin findclass apppath(the execuse app path)  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/objcthin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Objcthin project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/objcthin/blob/master/CODE_OF_CONDUCT.md).

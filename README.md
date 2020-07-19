# Bitfieldable

The `Bitfieldable` gem allows you to define a set of boolean flag attributes that are backed by a single integer bitfield.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitfieldable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bitfieldable

## Usage

For example, create a `User` model with an `int NOT NULL` field called `flags`, which defaults to 0.

```ruby
class User
  include Bitfieldable::Concern

  bitfields flags: %i[admin special shadowbanned]
end

user = User.new

user.admin? # false
user.admin!
user.admin? # true
user.flags # 1

user.flip_special!
user.special? # true
user.flags # 3

user.shadowbanned = true
user.shadowbanned? # true
user.flags # 7
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yasyf/bitfieldable.


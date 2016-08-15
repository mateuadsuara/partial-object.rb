# PartialObject
[![Gem Version](https://badge.fury.io/rb/partial_object.svg)](https://badge.fury.io/rb/partial_object)
[![Build Status](https://travis-ci.org/mateuadsuara/partial-object.rb.svg?branch=master)](https://travis-ci.org/mateuadsuara/partial-object.rb)

A way to easily define objects that take arguments at different places

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'partial_object'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install partial_object

## Usage

First, `include PartialObject` on the class.
Then, define the `required_parameter`s and/or the `optional_parameter`s.

After that, you'll be able to use the arguments by the defined parameter names.

Required arguments will raise `ArgumentError` when the argument is used but not passed.

Optional arguments will be `nil` when used but not passed.

Let me give you an example:

```ruby
class Person
  include PartialObject
  required_parameter :name, :last_name
  optional_parameter :language, :email

  def hey
    text = "Hey #{name} #{last_name}!"
    text += "\nI will contact you via #{email} in #{language || 'english'}" if email
    text
  end
end

jd = Person
  .new(:last_name => "D.")
  .partial(:language => "french")
  .partial(:name => "J.")

another_person = jd
  .partial(:name => "John", :email => "john@doe.com")

puts jd.hey
#=> Hey J. D.!

puts another_person.hey
#=> Hey John D.!
#=> I will contact you via john@doe.com in french
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mateuadsuara/partial-object.rb


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


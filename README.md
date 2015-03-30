# Tale

A DSL for writing and navigating stories. Very much still in the 'discovery' phase of development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tale'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tale

## Usage

Write chapters consisting of events. Events can have take actions and lead to consequences.

```ruby

class TheTavern < Tale::Chapter

  location :tavern do

    event do
      detail "The tavern ahead looks like a pile of wood and stone blew into place in the last storm."
    end

    event do
      character :protagonist
      dialogue "Guess this is the place..."
      action :open_door, "Open the the door"
    end

    event do
      character :tavernkeep
      dialogue "Welcome, stranger. What'll you have?"
      action :ale, "Ale"
      action :mead, "Mead"
    end

    event from: :ale do
      detail "Bleh, the ale is stale and hot..."
      consequence protagonist: :defend, :tavern_ale
    end

    event from: :mead do
      detail "Mmmm, the mead is sweet and tasty."
      consequence protagonist: :heal, :tavern_mead
    end

  end

end
```

Define your protagonist, locations and other characters, objects

```ruby

class Player
  include Tavern::Protagonist

  # These methods implementations are where you
  # customize your game

  def defend params
    # ... implementation is up to you from here
  end

  def heal params
    # ... implementation is up to you from here
  end

end

```

API for navigating chapters.

```ruby
  player = Player.new
  intro = Intro.new(player)

  intro.current_event
  # The tavern ahead looks like a pile of wood and stone blew into place in the last storm.

  intro.step!

  intro.current_event
  # Guess this is the place...
  # actions: "Open the door"

  intro.choose! :open_door
  intro.current_event
  # Tavernkeep: "Welcome, stranger. What'll you have?"
  # actions: "Ale" "Mead"

  intro.choose! :ale
  ...

```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/tale/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

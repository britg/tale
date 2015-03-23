require "tale/version"
require "tale/chapter"
require "tale/event"

module Tale

  def self.chapters
    @@chapters
  end

  def self.chapter name, &block
    @@chapters ||= []
    @@chapters << Tale::Chapter.new(name, &block)
  end

end

require "intro"

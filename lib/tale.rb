require "tale/version"
require "tale/chapter"
require "tale/event"

module Tale

  def self.chapter name, metadata = {}, &block
    Tale::Chapter.new(name, metadata, &block)
  end

end
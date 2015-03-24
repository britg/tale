module Tale
  class Chapter

    def self.sequence int
      @@sequence = int
    end

    def self.at location_ref, &block
      class_eval(&block)
    end

    def self.events
      @@events
    end

    def self.event opts = {}, &block
      @@events ||= []
      e = Tale::Event.new(opts, &block)
      @@events << e
      e
    end

    attr_accessor :character

    # Character must have two properties:
    # current_chapter_sequence
    # current_event_sequence

    def initialize _character
      @character = _character
      @current_event_index = 0
    end

    def next
      @event = @@events[@current_event_index]
      @current_event_index += 1
      @event
    end

  end
end
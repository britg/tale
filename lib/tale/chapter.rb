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
      e.sequence = @@events.count
      @@events << e
      e
    end

    attr_accessor :protagonist

    # Protagonist must have two properties:
    # current_chapter_sequence
    # current_event_sequence

    def initialize _protagonist
      @protagonist = _protagonist
    end

    def current_event
      @@events[current_event_sequence]
    end

    def next_event
      @@events[next_event_sequence]
    end

    def current_event_sequence
      @protagonist.current_event_sequence || 0
    end

    def next_event_sequence
      current_event_sequence + 1
    end

    def next_event_group
      return [] if current_event.has_actions?

      @event_group = []
      i = current_event_sequence
      loop do
        i += 1
        event = @@events[i]
        @event_group << event

        if event.has_actions?
          break
        end
      end

      @event_group
    end

    def proceed!
      @group = next_event_group
      if @group.any?
        last_event = @group.last
        @protagonist.update_attributes(current_event_sequence: last_event.sequence)
      end
      @group
    end

    def perform_action key, metadata = {}

    end

  end
end
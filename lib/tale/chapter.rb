module Tale
  class Chapter

    class << self
      attr_accessor :branch_cache
    end

    def self.sequence int
      @sequence = int
    end

    def self.location
      @location
    end

    def self.at location_ref, &block
      @location = location_ref
      class_eval(&block)
    end

    def self.events
      @events
    end

    def self.branch branch_name, &block
      @current_branch = branch_name
      class_eval(&block)
      @current_branch = nil
    end

    def self.event opts = {}, &block
      @events ||= {}
      @branch_cache ||= {}
      opts.merge!(branch: @current_branch)
      e = Tale::Event.make(opts, &block)
      @branch_cache[e.branch] ||= []
      @branch_cache[e.branch] << e
      e.sequence = @events.count
      @events[e.sequence] = e
      e
    end

    attr_accessor :current_event_sequence,
                  :current_branch

    def initialize sequence = nil
      @current_event_sequence = sequence||-1
    end

    def current_event
      return nil unless @current_event_sequence >= 0
      self.class.events[@current_event_sequence]
    end

    def next_event
      self.class.events[next_event_sequence]
    end

    def next_event_sequence
      @current_event_sequence + 1
    end

    def next_event!
      @next_event = next_event
      @current_event_sequence += 1
      @next_event
    end

    def next_event_group
      return [] if current_event.present? && current_event.has_actions?

      @event_group = []
      loop do
        @next_event = next_event!
        @event_group << @next_event
        break if @next_event.has_actions?
      end

      @event_group
    end

    def step!
      @current_event_sequence += 1
    end

    def choose! key, metadata = {}
      # temp
      step!
    end

  end
end
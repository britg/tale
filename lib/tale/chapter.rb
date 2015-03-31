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

    def action_available?
      current_event.present? && current_event.has_actions?
    end

    def action_required?
      current_event.present? && current_event.action_required?
    end

    def next_event
      if @current_branch.present? && branch_exists?(@current_branch)
        next_branch_event
      else
        raise "Action required" if action_required?
        next_non_branch_event
      end
    end

    def branch_exists? branch_name
      self.class.branch_cache[branch_name].present?
    end

    def branch_events
      self.class.branch_cache[@current_branch]
    end

    def next_branch_event
      branch_event = branch_events[@current_event_sequence + 1]
      if branch_event.nil?
        # leave branch
        @current_branch = nil
        return next_event
      else
        return branch_event
      end
    end

    def next_non_branch_event
      loop do
        this_event = self.class.events[@current_event_sequence + 1]
        return if this_event.nil?
        if this_event.branch.nil?
          return this_event
        end
      end
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

    def take_action! key, metadata = {}
      branch_name = key.to_sym
      if branch_exists?(branch_name)
        @current_branch = branch_name
        @event = branch_events.first
        @current_event_sequence = @event.sequence
        @event
      else
        next_event
      end
    end

  end
end
module Tale
  class Hero

    attr_accessor :chapter,
                  :current_sequence

    def initialize _chapter, _sequence = 1
      @chapter = _chapter
      @current_sequence = _sequence
      @current_event = @chapter.find_event(@current_sequence)
    end

    def current_branch
      @chapter.branches[@current_event.branch_name]
    end

    def current_event
      event = current_branch.seq(@current_sequence)
      @current_sequence = event.sequence
      event
    end

    def next_event
      raise "Action required" if current_event.action_required?
      event_or_exit = current_branch.seq(@current_sequence + 1)
      if event_or_exit.class == Symbol
        exit_branch = event_or_exit
        @current_event = @chapter.branches[exit_branch].seq(@current_sequence+1)
      else
        @current_event = event_or_exit
      end
      @current_sequence = @current_event.sequence
      @current_event
    end

    def take_action key
      raise "No action available" unless current_event.has_actions?

      branch_name = key.to_sym
      raise "Invalid action" unless current_event.action_valid?(branch_name)

      if @chapter.branch_exists? branch_name
        @current_event = @chapter.branches[branch_name].seq(@current_event.sequence)
      else
        next_event
      end
    end

  end
end
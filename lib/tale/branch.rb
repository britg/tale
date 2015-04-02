module Tale
  class Branch

    MAIN = :main

    attr_accessor :name,
                  :opts,
                  :events,
                  :max_sequence

    def initialize name, _opts = {}, chapter
      @name = name.to_sym
      @opts = opts||{}
      @chapter = chapter
      @events = {}
    end

    def parse &block
      instance_eval(&block)
    end

    def event opts = {}, &block
      # e = Tale::Event.make(opts, &block)
      sequence = @chapter.parse_sequence += 1
      opts.merge!(sequence: sequence,
                  branch_name: @name)
      @building_event = Tale::Event.new(opts)
      instance_eval(&block)
      @events[sequence] = @building_event
      @max_sequence = sequence
      @buidling_event = nil
    end

    def character ref
      @building_event.character_ref = ref
    end

    def detail text
      @building_event.detail = text
    end

    def dialogue text
      @building_event.dialogue = text
    end

    def action key, metadata = {}
      @building_event.actions[key] = { key: key }.merge(metadata)
    end

    def result key, metadata = {}
      @building_event.results[key] = { key: key }.merge(metadata)
    end

    def exit_branch
      @opts[:exit] || MAIN
    end

    def seq int
      if int > max_sequence
        puts "Out of branch bounds: #{name} #{int} / #{max_sequence}. Most likely this chapter did not end with an action!"
        return exit_branch
        # raise "Out of branch bounds: #{name} #{int} / #{max_sequence}"
      end
      found = @events[int]
      return found if found.present?
      seq(int+1)
    end

  end
end
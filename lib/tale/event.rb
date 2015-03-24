module Tale
  class Event

    attr_accessor :opts,
                  :detail,
                  :dialogue,
                  :character_ref,
                  :actions,
                  :results,
                  :sequence

    def initialize _opts = {}, &block
      @opts = _opts
      @actions = []
      @results = []
      instance_eval(&block)
    end

    def character ref
      @character_ref = ref
    end

    def detail text
      @detail = text
    end

    def dialogue text
      @dialogue = text
    end

    def action key, hash
      @actions << { key: key }.merge(hash)
    end

    def result type, metadata = {}
      @results << { type: type }.merge(metadata)
    end

    def no_actions?
      @actions.empty?
    end

    def has_actions?
      @actions.any?
    end

    def action_required?
      has_actions?
    end

  end
end
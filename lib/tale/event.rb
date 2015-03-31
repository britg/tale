module Tale
  class Event

    attr_accessor :opts,
                  :detail,
                  :dialogue,
                  :character_ref,
                  :actions,
                  :consequences,
                  :sequence,
                  :branch

    def self.make opts, &block
      reset!
      class_eval(&block)
      e = Tale::Event.new(opts)
      e.character_ref = @character_ref
      e.detail = @detail
      e.dialogue = @dialogue
      e.actions = @actions
      e.consequences = @consequences
      return e
    end

    def self.reset!
      @actions = []
      @consequences = []
      @character_ref = nil
      @detail = nil
      @dialogue = nil
    end

    def self.character ref
      @character_ref = ref
    end

    def self.detail text
      @detail = text
    end

    def self.dialogue text
      @dialogue = text
    end

    def self.action key, hash
      @actions << { key: key }.merge(hash)
    end

    def self.consequence type, metadata = {}
      @consequences << { type: type }.merge(metadata)
    end

    def initialize _opts
      @opts = _opts
      @branch = opts[:branch]
    end

    def actions
      @actions || []
    end

    def no_actions?
      actions.empty?
    end

    def has_actions?
      actions.any?
    end

    def action_required?
      actions.count > 1
    end

  end
end
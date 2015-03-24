module Tale
  class Event

    attr_accessor :opts,
                  :detail,
                  :dialogue,
                  :character_ref,
                  :actions,
                  :results

    def initialize _opts = {}, &block
      @opts = _opts
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
      @actions ||= []
      @actions << { key: key }.merge(hash)
    end

    def result type, metadata = {}
      @results ||= []
      @results << { type: type }.merge(metadata)
    end

  end
end
module Tale
  class Event

    attr_accessor :description

    def initialize description, &block
      @description = description
      instance_eval(&block)
    end

    def detail text
      puts "detail called from event"
    end

    def action hash
      puts "action called from event"
    end

  end
end
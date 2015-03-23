module Tale
  class Chapter

    attr_accessor :name,
                  :events

    def initialize name, &block
      @name = name
      instance_eval(&block)
    end

    def to_s
      @name
    end

    def location reference_slug
      puts "location called"
    end

    def event description, &block
      puts "event called"
      @events ||= []
      e = Tale::Event.new(description, &block)
      @events << e
      e
    end

  end
end
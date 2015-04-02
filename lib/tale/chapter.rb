module Tale
  class Chapter

    class << self
      attr_accessor :branches, :parse_sequence
    end

    def self.init
      @parse_sequence ||= 0
      @branches ||= {}
    end

    def self.main_branch
      init
      return @main_branch if @main_branch.present?
      @main_branch = @branches[Tale::Branch::MAIN] = Tale::Branch.new(Tale::Branch::MAIN, self)
    end

    def self.event opts = {}, &block
      main_branch.event opts, &block
    end

    def self.branch branch_name, opts = {}, &block
      init
      branch_name = branch_name.to_sym
      raise "Branch already exists" if @branches[branch_name].present?
      branch = Tale::Branch.new(branch_name, opts, self)
      @branches[branch_name] = branch
      branch.parse &block
    end

    def self.hero current_sequence = 1
      Tale::Hero.new(self, current_sequence)
    end

    def self.branch_exists? branch_name
      branch_name = branch_name.to_sym
      branches[branch_name].present?
    end

    def self.find_event seq
      branches.each do |name, branch|
        event = branch.events[seq]
        return event if event.present?
      end
      raise "Event not found"
    end

  end
end
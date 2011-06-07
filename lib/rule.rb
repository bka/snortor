module Snort
  class Rule
    attr_accessor :active

    def initialize(kwargs={})
      super(kwargs)
      @active=true
    end    
    #def self.parse(line)
    #  super.parse(line)
    #  @active=true
    #end

    def active=(a)
      @active = a
    end

    def message
      opts['msg']
    end
  end
end

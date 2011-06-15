# This module is provided by snort-rule gem.
# Only do a monkey patch here to have the activation ability of single rules.
module Snort
  # this class is extended to have activation ability of single rules
  class Rule
    attr_accessor :active
    attr_accessor :line


    def initialize(kwargs={})
      super(kwargs)
      @active=true
    end    

    def active=(a)
      @active = a
    end

    def message
      opts['msg']
    end

    #alias :old_parse :parse


    #def self.parse(line)
    #  super(line)
    #end
    def self.parse_rule(line)
      #puts "@line = #{line}"
      rule = self.parse(line)
      if rule.message
        rule.line = line
        return rule
      else
        return nil
      end
    end

    #def to_s
    #  return @line.to_s
    #end

    def to_line
      @line.to_s
    end
    
  end
end

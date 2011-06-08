# This module is provided by snort-rule gem.
# Only do a monkey patch here to have the activation ability of single rules.
module Snort
  # this class is extended to have activation ability of single rules
  class Rule
    attr_accessor :active

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
  end
end

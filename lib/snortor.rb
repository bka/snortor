require 'rubygems'
BASE = File.expand_path('..', __FILE__)

require 'snort-rule'
require File.join(BASE,'rule')
require File.join(BASE,'rulefile')
require File.join(BASE,'rulefile_collection')

module Snortor
  class << self
    @@rules = RulefileCollection.new

    def rules
      @@rules
    end

    def import_rules(path)
      clear
      @@rules.import_rules(path)
    end

    def write_rules(path)
      @@rules.write_rules(path)
    end
    alias :export_rules :write_rules

    def clear
      @@rules.clear
    end
    
    def find_by_msg(msg)
      @@rules.find_by_msg(msg)
    end

    def find_all_by_msg(msg)
      @@rules.find_all_by_msg(msg)
    end
  end
end

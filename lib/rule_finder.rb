module Snortor
  module RuleFinder
    def find_by_msg(title)
      self.each do |r|
        begin
          msg = r.opts["msg"]
          return r if msg[title]
        rescue
        end
      end
      return nil
    end

    def find_all_by_msg(title)
      res = []
      self.each do |rule|
        msg = rule.opts["msg"]
        if msg[title]
          res << rule 
        end
      end
      return res
    end
  end
end

require File.join(SNORTOR_BASE,'rule_loader')
require File.join(SNORTOR_BASE,'rule_finder')

module Snortor
  class RulefileCollection < Array
    include RuleLoader
    include RuleFinder

    alias_method :old_push, :<<
    alias_method :old_each, :each

    def <<(a)
      raise "only instances of Rulefile allowed" unless a.class == Rulefile
      old_push(a)
    end

    def [](index)
      offset = 0
      self.old_each do |rule_file|
        if index < offset+rule_file.size
          return rule_file[index-offset]
          break
        end
        offset += rule_file.size
      end
    end

    def size
      res = 0
      self.old_each do |rule_file|
        res += rule_file.size
      end
      res
    end

    def each(&block)
      self.old_each do |rulefile|
        rulefile.each do |rule|
          block.call(rule)
        end
      end
      nil
    end

    def import_rules(path)
      rulefile = nil
      if File.directory?(path)
        read_rules_from_dir(path) do |filepath,line|
          if rulefile == nil || rulefile.filepath != filepath
            #puts "base: #{path} and reading #{filepath}"

            rulefile = Rulefile.new(filepath)
            rulefile.calc_relative_path(path)
            self << rulefile
          end
          begin
            # only parse lines that seem to be a rule
            # maybe handle includes and comments as well
            if line["alert"]
              if line.strip[0] == "#"
                line[line.index("#")] = ""
                rule = Snort::Rule.parse_rule(line.strip)
                rule.active = false
                rulefile << rule if rule
              else
                rulefile << Snort::Rule.parse_rule(line.strip)
              end
            end
          rescue
            puts "Problem parsing line #{line} in #{filepath}"
          end
        end
      else

        read_rules_from_file(path) do |filepath,line|
          if rulefile == nil || rulefile.filepath != filepath
            #puts "base: #{path} and reading #{filepath}"

            rulefile = Rulefile.new(filepath)
            rulefile.calc_relative_path(path)
            self << rulefile
          end
          begin
            # only parse lines that seem to be a rule
            # maybe handle includes and comments as well
            if line["alert"]
              if line.strip[0] == "#"
                line[line.index("#")] = ""
                rule = Snort::Rule.parse_rule(line.strip)
                rule.active = false
                rulefile << rule if rule
              else
                rulefile << Snort::Rule.parse_rule(line.strip)
              end
            end
          rescue
            puts "Problem parsing line #{line} in #{filepath}"
          end
        end

      end
    end

    def write_rules(path)
      Dir.mkdir(path) if !File.exists?(path)
      self.old_each do |rulefile|
        begin
          dest = File.join(path,rulefile.relative_path,rulefile.filename)
          file = File.new(dest,"w")
        rescue Errno::ENOENT
          Dir.mkdir(File.join(path,rulefile.relative_path))
          file = File.new(dest,"w")
        end
        rulefile.each do |rf|
          if rf.active
            file.write(rf.to_line.gsub("\n","")+"\n")
          else
            file.write("# "+rf.to_line.gsub("\n","")+"\n")
          end
        end
        file.close
      end
    end
  end
end

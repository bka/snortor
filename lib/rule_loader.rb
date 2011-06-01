module Snortor
  module RuleLoader
    def read_rules_from_file(f,&block)
      file = File.new(f, "r")
      while (line = file.gets)
        block.call(f,line)
      end
    end

    def read_rules_from_dir(d,&block)
      Dir.foreach(d) do |filename|
        full_file_path = File.join(d,filename)
        next if filename == ".." || filename == "."

        if File.directory?(full_file_path)
          read_rules_from_dir(full_file_path,&block)
          next
        end
        read_rules_from_file(full_file_path,&block) if File.extname(full_file_path) == ".rules"
      end
    end
  end
end

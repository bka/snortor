module Snortor
  class Rulefile < Array
    attr_accessor :filename
    attr_accessor :filepath
    attr_accessor :relative_path

    def initialize(filepath)
      raise Errno::ENOENT unless File.exists?(filepath)
      @filepath = filepath
      @filename = File.basename(filepath)
    end

    def calc_relative_path(fullpath)
      workingdir = fullpath.split("/")
      thispath = @filepath.split("/")
      @relative_path = (thispath-workingdir-[filename]).join("/")
    end

    #alias_method :old_push, :<<

    #def <<(a)
    #  puts "ARRAY << #{a}"
    #  if self.size > 0
    #    raise "Not possible" if self[0].class != a.class
    #  end      
    #  old_push(a)
    #end
  end
end

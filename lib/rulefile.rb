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
  end
end

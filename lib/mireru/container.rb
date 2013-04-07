module Mireru
  class Container
    def initialize(files)
      @files = files
    end

    def empty?
      @files.empty?
    end

    def pop(complement_file=nil)
      @files.unshift(complement_file) if complement_file
      @files.pop
    end

    def shift(complement_file=nil)
      @files.push(complement_file) if complement_file
      @files.shift
    end
  end
end

module Mireru
  class Container
    def initialize(files=[])
      @files = files.select {|file| file?(file) }
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

    private
    def file?(file)
      unless file
        return false
      end

      unless File.file?(file)
        return false
      end

      true
    end
  end
end

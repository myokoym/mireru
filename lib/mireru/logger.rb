module Mireru
  class Logger
    def initialize
    end
  
    def info(message)
      puts(message)
    end
  
    def error(message)
      $stderr.puts(message)
    end
  end
end

class File
  def self.crfate(file,val)
    open(file,"w") do |f|
      f << val
    end
  end
end

module CloudFile
  class File
    include FromHash
    attr_accessor :loc, :service

    def read
      service.read(loc)
    end
    def write(val)
      service.write(loc,val)
    end
    def <<(*args)
      write(*args)
    end

    def read_format(format)
      service.read_format(format,loc)
    end
  end
end
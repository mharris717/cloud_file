module CloudFile
  class Local < Service
    register :provider => "local"
    uri_format ":file"
    
    def read(ops)
      ::File.read ops[:file]
    end
    def write(ops,val)
      ::File.create ops[:file],val
    end

    class << self
      def for_user(user)
        new
      end
    end
  end
end
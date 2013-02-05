module CloudFile
  class Memory < Service
    register :provider => "memory"
    uri_format ":key"

    def read(key)
      world[key.to_s]
    end
    def write(key,val)
      world[key.to_s] = val
    end
    fattr(:world) { {} }

    class << self
      fattr(:instance) { new }
      def method_missing(sym,*args,&b)
        instance.send(sym,*args,&b)
      end

      def for_user(user)
        instance
      end
    end
  end
end
module CloudFile
  class Service
    include FromHash
    fattr(:auth_hash) { {} }
    class << self
      def auth_value(*args)
        args.flatten.each do |meth|
          define_method(meth) do
            auth_hash[meth.to_s]
          end
          define_method("#{meth}=") do |val|
            auth_hash[meth.to_s] = val
          end
        end
      end
    end

    auth_value :access_token, :access_secret
    

    def read(ops)
      raise NotImplementedError.new("read")
    end
    def write(ops,val)
      raise NotImplementedError.new("write")
    end

    def read_format(target_format,ops)
      ::CloudFile::Convertors.convert(self.class.format,target_format,read(ops))
    end

    def files(*args)
      list(*args).map do |f|
        CloudFile::File.new(:service => self, :loc => f)
      end
    end

    

    def open(ops)
      file = CloudFile::File.new(:loc => ops, :service => self)
      if block_given?
        yield(file)
      end
      file
    end

    class << self
      def for_user(user)
        #puts user.identities.map { |x| x.provider }.inspect
        #puts name
        ident = user.identities.find { |x| x.provider == provider }
        new(:access_token => ident.access_token, :access_secret => ident.access_secret)
      end

      attr_accessor :provider, :format, :location_params
      def register(ops)
        ::CloudFile::Services << self
        ops.each do |k,v|
          send("#{k}=",v)
        end
      end
      def register_converter(ops,&b)
        ::CloudFile::Convertors.register(ops,&b)
      end

      def location_params(*args)
        if args.empty?
          instance_variable_get("@location_params")
        else
          self.location_params = args.flatten
        end
      end
    end

    
  end
end

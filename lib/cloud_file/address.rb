puts 'loading address'

module CloudFile
  class Address
    include FromHash
    attr_accessor :user, :provider, :loc

    def service
      cls = ::CloudFile::Services.service_class(provider)
      cls.for_user(user)
    end

    def open(&b)
      service.open(loc,&b)
    end

    def files
      service.files
    end

    class << self
      def parse(str)
        raise "bad #{str}" unless str =~ /^(.+):\/\/(.+)$/
        service_class = ::CloudFile::Services.service_class($1)
        loc = service_class.uri_parser.parse(str)
        provider = loc.delete('provider')

        make(:provider => provider, :user => Tokens.user, :loc => loc)
      end
      def make(ops)
        if ops[:loc]
          new(ops)
        else
          res = new
          res.user = ops.delete(:user)
          res.provider = ops.delete(:provider)
          res.loc = ops
          res
        end
      end
    end
  end
end
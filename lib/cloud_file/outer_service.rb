module CloudFile
  class OuterService
    include FromHash
    attr_accessor :service

    def parse_loc(loc)
      if loc.kind_of?(String)
        loc = service.class.uri_parser.parse(loc)
      end
      loc
    end

    def read(loc)
      raise 'foo'
      service.read parse_loc(loc)
    end

    def write(loc,val)
      service.write parse_loc(loc),val
    end
  end
end
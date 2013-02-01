module CloudFile
  class Services
    include FromHash

    fattr(:list) { [] }
    def <<(s)
      self.list << s
    end

    def service_class(provider)
      res = list.find { |x| x.provider.to_s == provider.to_s }
      if !res
        raise "no class found for #{provider}, ops are " + list.map { |x| x.provider }.inspect
      end
      res
    end

    class << self
      fattr(:instance) { new }
      def method_missing(sym,*args,&b)
        instance.send(sym,*args,&b)
      end
    end
  end
end
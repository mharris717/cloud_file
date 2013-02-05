module CloudFile
  class CloudUri
    class Dsl
      include FromHash
      attr_accessor :service_class, :format

      def self.regex
        /^(.+):\/\/([^\/]+)((?:\/[^\/]+)*)/
      end

      def matches(str)
        raise "no matches" unless str =~ self.class.regex

        res = [$1,$2]
        if $3.present?
          res += $3[1..-1].split("/")
        end
        res
      end

      def params
        [':provider'] + format.split("/")
      end

      def result(str)
        matches = matches(str)
        res = {}
        add = lambda do |k,i|
          val = matches[i]
          if val.kind_of?(Array)
            raise "bad" if val.empty?
            val = val.join("/")
          else
            raise "bad" unless val.present?
          end
          res[k] = val
        end

        params.each_with_index do |param,i|
          if param =~ /^:/
            k = param[1..-1]
            add[k,i]
          elsif param =~ /^*:/
            k = param[2..-1]
            add[k,(i..99)]
          else
            # do nothing
          end
        end

        HashWithIndifferentAccess.new(res)
      end
      def parse(str)
        result(str)
      end

      def run!
        service_class.uri_parser = self
      end
    end
  end
end

def process_route(route, pattern, keys, conditions, block = nil, values = [])
  route = '/' if route.empty? and not settings.empty_path_info?
  return unless match = pattern.match(route)
  values += match.captures.to_a.map { |v| force_encoding URI.decode(v) if v }

  if values.any?
    original, @params = params, params.merge('splat' => [], 'captures' => values)
    keys.zip(values) { |k,v| Array === @params[k] ? @params[k] << v : @params[k] = v if v }
  end

  catch(:pass) do
    conditions.each { |c| throw :pass if c.bind(self).call == false }
    block ? block[self, values] : yield(self, values)
  end
ensure
  @params = original if original
end
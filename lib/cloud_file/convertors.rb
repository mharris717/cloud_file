module CloudFile
  class Convertors
    class << self
      fattr(:instance) { new }
      def method_missing(sym,*args,&b)
        instance.send(sym,*args,&b)
      end
    end

    include FromHash
    fattr(:list) { [] }
    def register(ops,&b)
      #puts "ops #{ops.inspect}"
      self.list = list.reject { |x| x[:from].to_s == ops.keys.first.to_s && x[:to].to_s == ops.values.first.to_s }
      self.list << {:from => ops.keys.first.to_s, :to => ops.values.first.to_s, :block => b}
    end
    def convert_inner(from,to,str)
      block = list.find { |x| x[:from].to_s == from.to_s && x[:to].to_s == to.to_s }
      raise "no convertor" unless block
      block[:block][str]
    end
    def convert(from,to,str)
      path = find_path(from,to)
      raise "no path from #{from} to #{to}" unless path
      if path.empty?
        convert_inner(from,to,str)
      else
        str = convert_inner(from,path.first,str)
        convert(path.first,to,str)
      end
    end

    def graph
      require 'rgl/adjacency'
      a = []
      list.each do |c|
        a << c[:from]
        a << c[:to]
      end
      RGL::DirectedAdjacencyGraph[*a]
    end

    def find_path(source,target,prev=[])
      raise "bad" if target.to_s == source.to_s
      tos = list.select { |x| x[:from] == source.to_s }.map { |x| x[:to] }
      puts "tos #{tos.inspect}"
      if tos.any? { |x| x == target.to_s }
        prev
      elsif tos.empty?
        nil
      else
        tos.each do |to|
          p = prev + [to]
          res = find_path(to,target,p)
          return res if res
        end
        nil
      end
    end
  end
end

CloudFile::Convertors.register :html => :text do |str|
  #str.gsub(/<[^>]+>/,"")
  require 'nokogiri'

  doc = Nokogiri::HTML(str)
  if doc.css("body").length > 0
    doc.css("body").text
  else
    doc.text
  end
end




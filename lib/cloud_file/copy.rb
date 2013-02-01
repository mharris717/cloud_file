module CloudFile
  class Copy
    include FromHash
    attr_accessor :source, :target, :format

    def run!
      CloudFile.open(source) do |s|
        CloudFile.open(target) do |t|
          t << s.read_format(format || t.service.class.format)
        end
      end
    end
  end
end
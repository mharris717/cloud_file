Bundler.require(:default)

module CloudFile
  class << self
    def open(*args,&b)
      address = make_address(*args)
      address.open(&b)
    end

    def make_address(*args)
      if args.first.kind_of?(::CloudFile::Address)
        args.first
      elsif args.length == 3
        user,provider,loc = *args
        ::CloudFile::Address.make(:user => user, :provider => provider, :loc => loc)
      elsif args.length == 1 && args.first.kind_of?(Hash)
        ::CloudFile::Address.make(args.first)
      else
        raise "can't make address"
      end
    end

    def copy(source,target,format=nil)
      source = ::CloudFile::Address.make(source) if source.kind_of?(Hash)
      target = ::CloudFile::Address.make(target) if target.kind_of?(Hash)

      copy = ::CloudFile::Copy.new(:source => source, :target => target, :format => format)
      copy.run!
    end

    def files(*args)
      address = make_address(*args)
      address.files
    end
  end
end

files = []
files += %w(address convertors copy file service services)
files += %w(dropbox evernote gdrive local)
files.each do |f|
  file = File.expand_path(File.dirname(__FILE__)) + "/cloud_file/#{f}.rb"
  puts "loading #{file}"
  load file
end

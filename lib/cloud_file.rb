Bundler.require(:default)

class Object
  def blank?
    to_s.strip == ''
  end
  def present?
    !blank?
  end
end

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
      elsif args.length == 1 && args.first.kind_of?(String) && args.first =~ /:\/\//
        ::CloudFile::Address.parse(args.first)
      else
        raise "can't make address"
      end
    end

    def copy(source,target,format=nil)
      #source = ::CloudFile::Address.make(source) if source.kind_of?(Hash)
      #target = ::CloudFile::Address.make(target) if target.kind_of?(Hash)

      #source = make_address(source)
      #target = make_address(target)

      #puts source.inspect
      #puts target.inspect

      copy = ::CloudFile::Copy.new(:source => source, :target => target, :format => format)
      copy.run!
    end

    def files(*args)
      address = make_address(*args)
      address.files
    end

    def read(*args)
      res = nil
      open(*args) do |f|
        res = f.read
      end
      res
    end

    def write(*args)
      val = args.pop
      res = nil
      open(*args) do |f|
        f.write val
      end
      res
    end
  end
end

class Tokens
  class << self
    fattr(:instance) { new }
    def method_missing(sym,*args,&b)
      instance.send(sym,*args,&b)
    end
  end
  fattr(:raw) do
    File.read("/code/explore/multiauth/lib/tokens.json")
  end
  fattr(:list) do
    require 'json'
    JSON.parse raw
  end
  def get_token(provider)
    list.select { |x| x['provider'] == provider.to_s }.first['access_token']
  end
  def user
    require 'ostruct'
    res = OpenStruct.new(:identities => [])
    list.each do |ident|
      res.identities << OpenStruct.new(ident)
    end
    res
  end
end

require 'active_support/core_ext/hash/indifferent_access'

files = []
files += %w(address convertors copy file service services cloud_uri)
files += %w(dropbox evernote gdrive local memory).map { |x| "providers/#{x}" }
files.each do |f|
  file = File.expand_path(File.dirname(__FILE__)) + "/cloud_file/#{f}.rb"
  #puts "loading #{file}"
  load file
end

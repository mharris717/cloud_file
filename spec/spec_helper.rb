$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'cloud_file'

Bundler.require(:test)

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
end

VCR.configure do |c|
  c.cassette_library_dir = File.dirname(__FILE__) + '/cassettes'
  c.hook_into :webmock # or :fakeweb
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

#puts Tokens.list.inspect
#puts Tokens.get_token('putio')

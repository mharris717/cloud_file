::Dropbox::API::Config.app_key    = "wncno17ygixgpy2"
::Dropbox::API::Config.app_secret = "om9yb57exzqb201"
::Dropbox::API::Config.mode       = "dropbox"

module CloudFile
  
  class Dropbox < Service
    register :provider => "dropbox", :format => :text
    fattr(:client) do
      puts "token #{access_token} secret #{access_secret}"
      ::Dropbox::API::Client.new :token => access_token, :secret => access_secret
    end
    def read(loc)
      puts 'url'
      url = client.find(loc[:path]).direct_url
      puts url
      puts "about to read #{loc[:path]}"
      client.download(loc[:path])
    end
    def write(loc,content)
      client.upload loc[:path],content
    end
  end
end
module CloudFile
  class Gdrive < Service
    register :provider => "google_oauth2", :format => :gdoc
    uri_format ":title"

    fattr(:client) do
      GoogleDrive.login_with_oauth(access_token)
    end

    def temp_file
      "/users/mharris717/multi.txt"
    end

    def read(loc)
      file = client.file_by_title(loc[:title])
      file.download_to_file temp_file
      ::File.read temp_file
    end

    def write(loc,val)
      ::File.create temp_file,val
      client.upload_from_file(temp_file, loc[:title], :convert => true)
    end

    def list
      client.files.map do |f|
        if f.title.downcase =~ /interview/
          ::File.create "entry.xml",f.document_feed_entry.to_s 
          raise 'foo'
        end
        {:title => f.title}
      end
    end

    register_converter :gdoc => :html do |str|
      str
    end
  end
end
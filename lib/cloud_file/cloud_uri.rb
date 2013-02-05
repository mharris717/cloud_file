%w(dsl).each do |f|
  load File.expand_path(File.dirname(__FILE__)) + "/cloud_uri/#{f}.rb"
end

module CloudFile
  class CloudUri
    include FromHash

  end
end

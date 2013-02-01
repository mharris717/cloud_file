require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CloudFile" do
  use_vcr_cassette "most"
  it "smoke" do
    2.should == 2
  end
  it 'dropbox read' do
    CloudFile.open(:user => Tokens.user, :provider => "dropbox", :loc => {:path => "docs/pain.txt"}) do |f|
      str = f.read
      puts f.read
      f.read.should be
    end
  end
end

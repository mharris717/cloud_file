require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

vcr_options = { :cassette_name => "most", :record => :new_episodes }
describe "CloudFile", :vcr => vcr_options do
  it "smoke" do
    2.should == 2
  end

  it 'dropbox read' do
    CloudFile.open(:user => Tokens.user, :provider => "dropbox", :loc => {:path => "test/abc.txt"}) do |f|
      str = f.read
      #puts f.read
      f.read.should == 'foo'
    end
  end

  it 'dropbox 2' do
    CloudFile.read("dropbox://test/abc.txt").should == 'foo'
  end
end

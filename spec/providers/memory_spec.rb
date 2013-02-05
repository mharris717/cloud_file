require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Memory' do
  before do
    CloudFile.write("memory://abc","hello")
  end

  it 'read' do
    CloudFile.read("memory://abc").should == 'hello'
  end

  it 'read empty' do
    CloudFile.read("memory://abcd").should_not be
  end

  it 'copy' do
    CloudFile.copy "memory://abc","memory://xyz"
    CloudFile.read("memory://xyz").should == 'hello'
  end

  it 'copy 2' do
    #CloudFile.copy "memory://abc", "dropbox://docs/abc.txt"
  end
end
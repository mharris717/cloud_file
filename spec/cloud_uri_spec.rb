require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CloudUri" do
  describe 'smoke parsing' do
    it 'parses' do
      "dropbox://docs/pain.txt".should parse_as_cloud_uri
    end
    it 'fails' do
      "dropbox:/docs/pain.txt".should_not parse_as_cloud_uri
    end
  end

  describe "raw matches" do
    it 'smoke' do
      "dropbox://pain.txt".should have_cloud_uri_matches(%w(dropbox pain.txt))
    end
    it 'basic' do
      "dropbox://docs/pain.txt".should have_cloud_uri_matches(%w(dropbox docs pain.txt))
    end
    it 'more' do
      "dropbox://docs/stuff/pain.txt".should have_cloud_uri_matches(%w(dropbox docs stuff pain.txt))
    end
  end

  describe 'result' do
    let(:dsl) do
      CloudFile::CloudUri::Dsl.new(:format => format)
    end

    describe 'basic' do
      let(:format) do
        ":file"
      end
      it 'smoke' do
        dsl.result("dropbox://pain.txt").should == {'provider' => "dropbox", "file" => "pain.txt"}
      end
    end

    describe 'sub' do
      let(:format) do
        ":notebook/:title"
      end
      it 'smoke' do
        dsl.result("evernote://stuff/foo").should == {'provider' => "evernote", "notebook" => "stuff", "title" => "foo"}
      end
    end

    describe 'splat' do
      let(:format) do
        "*:path"
      end
      it 'smoke' do
        dsl.result("dropbox://stuff/foo.txt").should == {'provider' => "dropbox", "path" => "stuff/foo.txt"}
      end
    end

    describe 'splat sub' do
      let(:format) do
        ":dir/*:path"
      end
      it 'smoke' do
        dsl.result("dropbox://stuff/foo.txt").should == {'provider' => "dropbox", "dir" => "stuff", "path" => "foo.txt"}
      end
    end
  end
end

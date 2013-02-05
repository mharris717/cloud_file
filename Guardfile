guard 'spork' do
  #watch('lib/**/*.rb')
  #watch('spec/**/*.rb')
  watch("tmp/restart_spork.txt")
end

guard 'rspec', :cli => "--drb" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})    { "spec" } # { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
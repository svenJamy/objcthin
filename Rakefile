require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :install do |t, args|
  system 'gem build objcthin.gemspec'
  path = Dir.glob('*.gem').last
  system "gem install -l #{path}"
  FileUtils.rm Dir.glob('*.gem')
  puts 'completed'
end

task :publish do |t, args|
  system 'gem build objcthin.gemspec'
  path = Dir.glob('*.gem').last
  command = "gem publish #{path}"
  system command
  FileUtils.rm Dir.glob('*.gem')
  puts 'completed'
end
# fix error: cant convert nil into String
# Rakefile:1 in include?
unless ENV['GEM_HOME'] && (__FILE__.include? ENV['GEM_HOME'])
  require 'bundler'
  Bundler::GemHelper.install_tasks
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

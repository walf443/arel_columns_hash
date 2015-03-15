require "bundler/gem_tasks"
require "rake/testtask"

task default: :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end


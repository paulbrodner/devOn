require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.verbose = false
end

desc "Run tests"
task :default => :test

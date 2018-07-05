require "rubygems"
require 'rake'
require 'rake/testtask'
require 'rake/clean'

CLEAN.include("**/*.gem", "**/*.rbc")

Rake::TestTask.new do |t|
  t.verbose = true
  t.warning = true
end

task :default => :test

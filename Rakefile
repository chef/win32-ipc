require "rake/testtask"
require "rake/clean"

CLEAN.include("**/*.gem", "**/*.rbc")

Rake::TestTask.new do |t|
  t.verbose = true
  t.warning = true
end

begin
  require "yard"
  YARD::Rake::YardocTask.new(:docs)
rescue LoadError
  puts "yard is not available. bundle install first to make sure all dependencies are installed."
end

begin
  require "chefstyle"
  require "rubocop/rake_task"
  desc "Run Chefstyle tests"
  RuboCop::RakeTask.new(:style) do |task|
    task.options += ["--display-cop-names", "--no-color"]
  end
rescue LoadError
  puts "chefstyle gem is not installed. bundle install first to make sure all dependencies are installed."
end
task :console do
  require "irb"
  require "irb/completion"
  ARGV.clear
  IRB.start
end

task default: :test

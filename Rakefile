require 'rake'
require 'rake/testtask'
require 'rbconfig'
include Config

desc 'Install the win32-ipc package (non-gem)'
task :install do
   sitelibdir = CONFIG['sitelibdir']
   installdir = File.join(sitelibdir, 'win32')
   file = File.join('lib', 'win32', 'ipc.rb')
   
   Dir.mkdir(installdir) unless File.exists?(installdir)
   FileUtils.cp(file, installdir, :verbose => true)   
end

Rake::TestTask.new do |t|
   t.verbose = true
   t.warning = true
end

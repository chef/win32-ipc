require 'rubygems'

spec = Gem::Specification.new do |gem|
   gem.name      = 'win32-ipc'
   gem.version   = '0.5.2'
   gem.authors   = ['Daniel J. Berger', 'Park Heesob']
   gem.license   = 'Artistic 2.0'
   gem.email     = 'djberg96@gmail.com'
   gem.homepage  = 'http://www.rubyforge.org/projects/win32utils'
   gem.platform  = Gem::Platform::RUBY
   gem.summary   = 'An abstract base class for Windows synchronization objects.'
   gem.test_file = 'test/test_win32_ipc.rb'
   gem.has_rdoc  = true
   gem.files     = Dir['**/*'].reject{ |f| f.include?('CVS') }

   gem.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']
   gem.rubyforge_project = 'win32utils'

   gem.add_dependency('windows-pr', '>= 1.0.6')

   gem.description = <<-EOF
      The win32-ipc library provides the Win32::IPC class. This is meant to
      serve as an abstract base class for other IPC related libraries for MS
      Windows, such as win32-semaphore, win32-event, and so on.
   EOF
end

Gem::Builder.new(spec).build

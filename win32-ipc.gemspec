require 'rubygems'

Gem::Specification.new do |spec|
  spec.name      = 'win32-ipc'
  spec.version   = '0.5.3'
  spec.authors   = ['Daniel J. Berger', 'Park Heesob']
  spec.license   = 'Artistic 2.0'
  spec.email     = 'djberg96@gmail.com'
  spec.homepage  = 'http://www.rubyforge.org/projects/win32utils'
  spec.platform  = Gem::Platform::RUBY
  spec.summary   = 'An abstract base class for Windows synchronization objects.'
  spec.test_file = 'test/test_win32_ipc.rb'
  spec.has_rdoc  = true
  spec.files     = Dir['**/*'].reject{ |f| f.include?('git') }

  spec.extra_rdoc_files  = ['README', 'CHANGES', 'MANIFEST']
  spec.rubyforge_project = 'win32utils'

  spec.add_dependency('windows-pr', '>= 1.0.6')

  spec.description = <<-EOF
    The win32-ipc library provides the Win32::IPC class. This is meant to
    serve as an abstract base class for other IPC related libraries for MS
    Windows, such as win32-semaphore, win32-event, and so on.
  EOF
end
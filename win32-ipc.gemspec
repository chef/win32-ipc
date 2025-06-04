Gem::Specification.new do |spec|
  spec.name       = "win32-ipc"
  spec.version    = "0.8.0"
  spec.authors    = ["Daniel J. Berger", "Park Heesob"]
  spec.license    = "Apache-2.0"
  spec.email      = "djberg96@gmail.com"
  spec.homepage   = "http://github.com/chef/win32-ipc"
  spec.summary    = "An abstract base class for Windows synchronization objects."
  spec.test_file  = "test/test_win32_ipc.rb"
  spec.files      = Dir["**/*"].reject { |f| f.include?("git") || f.end_with?(".gem") }

  spec.extra_rdoc_files = ["README.md", "CHANGELOG.md"]

  spec.add_dependency "ffi"
  spec.add_development_dependency "test-unit"

  spec.description = <<-EOF
    The win32-ipc library provides the Win32::IPC class. This is meant to
    serve as an abstract base class for other IPC related libraries for MS
    Windows, such as win32-semaphore, win32-event, and so on.
  EOF
end

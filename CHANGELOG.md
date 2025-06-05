# win32-ipc Changelog
<!-- latest_release 0.8.0 -->
## [win32-ipc-0.8.0](https://github.com/chef/win32-ipc/tree/win32-ipc-0.8.0) (2025-06-05)

#### Merged Pull Requests
- Updating for Ruby 3.4 and Cookstyle [#47](https://github.com/chef/win32-ipc/pull/47) ([johnmccrae](https://github.com/johnmccrae))
<!-- latest_release -->
<!-- release_rollup since=0.7.0 -->
### Changes not yet released to rubygems.org

#### Merged Pull Requests
- Updating for Ruby 3.4 and Cookstyle [#47](https://github.com/chef/win32-ipc/pull/47) ([johnmccrae](https://github.com/johnmccrae)) <!-- 0.8.0 -->
<!-- release_rollup -->

<!-- latest_stable_release -->
== 0.7.0 - 22-Jun-2016
* The license is now Apache 2.0.
<!-- latest_stable_release -->


== 0.6.6 - 13-Sep-2015
* The gem is now signed.
* Added the win32-ipc.rb file for convenience.

== 0.6.5 - 7-Jul-2015
* Fixed the wait_for_multiple method for x64 platforms. Thanks go to Rafal
  Bigaj for the spot and patch.

== 0.6.4 - 1-Jul-2015
* Fixed boolean argument type parameter. Thanks go to Rafal Bigaj for the patch.
* Updates to gemspec and Rakefile.

== 0.6.3 - 10-Jan-2015
* Declare the FFI prototype for WaitForSingleObject as blocking.

== 0.6.2 - 10-Jan-2015
* Declare the FFI prototype for WaitForMultipleObjects as blocking.

== 0.6.1 - 9-Apr-2013
* Updated the HANDLE function prototypes in the underlying FFI code. This
  affects 64 bit versions of Ruby.

== 0.6.0 - 8-Jul-2012
* Now uses FFI instead of win32-api.
* The #signaled? method now has a meaningful default implementation.
* If an internal C function fails it raises a SystemCallError (Errno) instead
  of an Ipc::Error.
* The Ipc::Error class, although defined for those who wish to still use it
  in inherited classes, is no longer used internally.

== 0.5.3 - 19-Apr-2010
* Added a few gem related tasks to the Rakefile, and removed an old install
  task.
* Removed the inline gem building code from the gemspec. That's now handled
  by a Rake task.
* Some cosmetic changes to the source code.

== 0.5.2 - 6-Aug-2009
* License changed to Artistic 2.0.
* Some gemspec updates, including an updated description and adding a
  license attribute.
* Renamed the test file to test_win32_ipc.rb.

== 0.5.1 - 1-Jan-2008
* Fixed bugs in the private wait_for_multiple method. Thanks go to an
  anonymous user for the spot and the patch.
* Removed the install.rb file. Installation was merged into the Rakefile.
* Updated the MANIFEST.

== 0.5.0 - 30-Apr-2007
* Now pure Ruby.
* Ipc.new no longer accepts a block.
* Changed IpcError to Ipc::Error.
* Removed the 'doc' directory.  The documentation is now inlined via rdoc.
* Added a gemspec.
* Added a Rakefile, including tasks for installation and testing.

== 0.4.1 - 23-Jan-2005
* Minor internal modifications for handling block arguments.

== 0.4.0 - 16-Dec-2004
* Changed the timeout from milliseconds to seconds.  This wasn't documented,
  and I'm guessing most people didn't know that they were passing milliseconds
  instead of seconds.  But, I've bumped the version number, just in case.

== 0.3.1 - 11-Dec-2004
* Fixed a bug in Ipc#wait where a segfault would occur if a block was not
  provided.
* Moved the 'examples' directory to the toplevel directory.

== 0.3.0 - 31-Oct-2004
* The constructor now takes an optional block.  Instance objects will call
  that block if they are signaled.
* Added the 'block' method (read-only).  Allows you to access the block
  provided to the constructor.
* Modified the 'wait' instance method to take an optional block.  This block
  will be called if the object is signaled.  Overrides the block to the
  constructor for that instance object (only).
* Added the 'signaled?' instance method to indicate if the object is in the
  signaled state or not.
* Modified all methods to raise an IpcError if an error occurs (instead of
  simply returning nil).
* Added internal comments in order to make the code rdoc friendly, including
  changes to the README file.

== 0.2.0 - 15-Jul-2004
* Updated to use the newer allocation framework.  This means that as of
  version 0.2.0, this package requires Ruby 1.8.0 or later.
* Moved the test.rb script to docs/examples.
* Minor code cleanup

== 0.1.0 - 30-Apr-2004
* Initial release
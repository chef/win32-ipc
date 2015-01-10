##########################################################################
# test_win32_ipc.rb
#
# Test case for the Win32::Ipc class.  Note that this class is rather
# difficult to test directly since it is meant to be subclassed, not
# used directly.
#
# You should run this test via the 'rake test' task.
##########################################################################
require 'win32/ipc'
require 'test-unit'
include Win32

class TC_Win32_Ipc < Test::Unit::TestCase
  def setup
    @ipc = Ipc.new(1)
  end

  test "version is set to expected value" do
    assert_equal('0.6.3', Ipc::VERSION)
  end

  test "handle method basic functionality" do
    assert_respond_to(@ipc, :handle)
    assert_equal(1, @ipc.handle)
  end

  test "signaled? method is defined" do
    assert_respond_to(@ipc, :signaled?)
  end

  test "wait method is defined" do
    assert_respond_to(@ipc, :wait)
  end

  test "wait raises ENXIO if handle is invalid" do
    assert_raises(Errno::ENXIO){ @ipc.wait }
  end

  test "wait accepts a maximum of one argument" do
    assert_raises(ArgumentError){ @ipc.wait(1,2) }
  end

  test "wait_any method is defined" do
    assert_respond_to(@ipc, :wait_any)
  end

  test "wait_any raises an ArgumentError if the array is empty" do
    assert_raises(ArgumentError){ @ipc.wait_any([]) }
  end

  test "wait_any only accepts an array" do
    assert_raises(TypeError){ @ipc.wait_any(1,2) }
  end

  test "wait_all method is defined" do
    assert_respond_to(@ipc, :wait_all)
  end

  test "wait_all raises an ArgumentError if the array is empty" do
    assert_raises(ArgumentError){ @ipc.wait_all([]) }
  end

  test "wait_all only accepts an array" do
    assert_raises(TypeError){ @ipc.wait_all(1,2) }
  end

  test "close method basic functionality" do
    assert_respond_to(@ipc, :close)
    assert_nothing_raised{ @ipc.close }
  end

  test "expected constants are defined" do
    assert_not_nil(Ipc::SIGNALED)
    assert_not_nil(Ipc::ABANDONED)
    assert_not_nil(Ipc::TIMEOUT)
  end

  test "ffi functions are private" do
    assert_not_respond_to(Ipc, :CloseHandle)
    assert_not_respond_to(Ipc, :WaitForSingleObject)
    assert_not_respond_to(Ipc, :WaitForMultipleObjects)
  end

  def teardown
    @ipc = nil
  end
end

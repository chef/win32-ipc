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

  def test_version
    assert_equal('0.6.0', Ipc::VERSION)
  end

  def test_handle
    assert_respond_to(@ipc, :handle)
    assert_equal(1, @ipc.handle)
  end

  def test_signaled
    assert_respond_to(@ipc, :signaled?)
    assert_equal(false, @ipc.signaled?)
  end

  def test_wait
    assert_respond_to(@ipc, :wait)
  end

  def test_wait_expected_errors
    assert_raises(Errno::ENXIO){ @ipc.wait }
    assert_raises(ArgumentError){ @ipc.wait(1,2) }
  end

  def test_wait_any
    assert_respond_to(@ipc, :wait_any)
  end

  def test_wait_any_expected_errors
    assert_raises(Ipc::Error){ @ipc.wait_any([]) }
    assert_raises(TypeError){ @ipc.wait_any(1,2) }
  end

  def test_wait_all
    assert_respond_to(@ipc, :wait_all)
  end

  def test_wait_all_expected_errors
    assert_raises(Ipc::Error){ @ipc.wait_all([]) }
    assert_raises(TypeError){ @ipc.wait_all(1,2) }
  end

  def test_close
    assert_respond_to(@ipc, :close)
    assert_nothing_raised{ @ipc.close }
  end

  def test_constants
    assert_not_nil(Ipc::SIGNALED)
    assert_not_nil(Ipc::ABANDONED)
    assert_not_nil(Ipc::TIMEOUT)
  end

  def test_ffi_methods_are_private
    assert_not_respond_to(Ipc, :CloseHandle)
    assert_not_respond_to(Ipc, :WaitForSingleObject)
    assert_not_respond_to(Ipc, :WaitForMultipleObjects)
  end

  def teardown
    @ipc = nil
  end
end

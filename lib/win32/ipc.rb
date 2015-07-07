require 'ffi'

# The Win32 module serves as a namespace only.
module Win32

  # This is a an abstract base class for IPC related classes, such as
  # Events and Semaphores.
  #
  class Ipc
    extend FFI::Library
    typedef :ulong, :dword
    typedef :uintptr_t, :handle

    ffi_lib :kernel32

    attach_function :CloseHandle, [:handle], :bool
    attach_function :WaitForSingleObject, [:handle, :dword], :dword, :blocking => true
    attach_function :WaitForMultipleObjects, [:dword, :pointer, :bool, :dword], :dword, :blocking => true

    private_class_method :CloseHandle, :WaitForSingleObject, :WaitForMultipleObjects

    # The version of the win32-ipc library
    VERSION = '0.6.5'

    SIGNALED  = 1
    ABANDONED = -1
    TIMEOUT   = 0
    INFINITE  = 0xFFFFFFFF

    WAIT_OBJECT_0    = 0
    WAIT_TIMEOUT     = 0x102
    WAIT_ABANDONED   = 128
    WAIT_ABANDONED_0 = WAIT_ABANDONED
    WAIT_FAILED      = 0xFFFFFFFF

    # The HANDLE object (an unsigned long value).  Mostly provided for
    # subclasses to use internally when needed.
    #
    attr_reader :handle

    # Creates and returns a new IPC object.  Since the IPC class is meant
    # as an abstract base class, you should never call this method directly.
    #
    def initialize(handle)
      @handle   = handle
      @signaled = false
    end

    # Closes the handle object provided in the constructor.
    #
    def close
      CloseHandle(@handle)
    end

    # Returns whether or not the IPC object is in a signaled state.
    #--
    # This method assumes a single object. You may need to redefine this
    # to suit your needs in your subclass.
    #
    def signaled?
      state = WaitForSingleObject(@handle, 0)

      if state == WAIT_FAILED
        raise SystemCallError.new("WaitForSingleObject", FFI.errno)
      elsif state == WAIT_OBJECT_0
        @signaled = true
      else
        @signaled = false
      end

      @signaled
    end

    # call-seq:
    #   Ipc#wait(timeout)
    #   Ipc#wait(timeout){ block called when signaled }
    #
    # Waits for the calling object to be signaled.  The +timeout+ value is
    # the maximum time to wait, in seconds. A timeout of 0 returns immediately.
    #
    # Returns SIGNALED (1), ABANDONED (-1) or TIMEOUT (0). Raises a
    # SystemCallError (Errno) if the wait fails for some reason.
    #
    def wait(timeout = INFINITE)
      timeout *= 1000 if timeout && timeout != INFINITE

      wait = WaitForSingleObject(@handle, timeout)

      case wait
        when WAIT_FAILED
          raise SystemCallError.new("WaitForSingleObject", FFI.errno)
        when WAIT_OBJECT_0
          @signaled = true
          yield if block_given?
          return SIGNALED
        when WAIT_ABANDONED
          return ABANDONED
        when WAIT_TIMEOUT
          return TIMEOUT
        else
          raise SystemCallError.new("WaitForSingleObject", FFI.errno)
      end
    end

    # :call-seq:
    #   IPC#wait_any([ipc_objects], timeout = INFINITE)
    #
    # Waits for at least one of the +ipc_objects+ to be signaled. The
    # +timeout+ value is maximum time to wait in seconds. A timeout of 0
    # returns immediately.
    #
    # Returns the index+1 of the object that was signaled. If multiple
    # objects are signaled, the one with the lowest index is returned.
    # Returns 0 if no objects are signaled.
    #
    def wait_any(ipc_objects, timeout=INFINITE)
      timeout *= 1000 if timeout && timeout != INFINITE
      wait_for_multiple(ipc_objects, false, timeout)
    end

    # :call-seq:
    #   IPC#wait_all([ipc_objects], timeout = INFINITE)
    #
    # Identical to IPC#wait_any, except that it waits for all +ipc_objects+
    # to be signaled instead of just one.
    #
    # Returns the index of the last object signaled. If at least one of the
    # objects is an abandoned mutex, the return value is negative.
    #
    def wait_all(ipc_objects, timeout=INFINITE)
      timeout *= 1000 if timeout && timeout != INFINITE
      wait_for_multiple(ipc_objects, true, timeout)
    end

    private

    # Waits until one or all (depending on the value of +wait_all+) of the
    # +ipc_objects+ are in the signaled state or the +timeout+ interval
    # elapses.
    #
    def wait_for_multiple(ipc_objects, wait_all=false, timeout=INFINITE)
      unless ipc_objects.is_a?(Array)
        msg = 'invalid argument - must be an array of Ipc objects'
        raise TypeError, msg
      end

      length = ipc_objects.size

      if length == 0
        raise ArgumentError, 'no objects to wait for'
      end

      ptr = FFI::MemoryPointer.new(:pointer, length)

      handles = ipc_objects.map(&:handle)
      ptr.write_array_of_pointer(handles)

      wait = WaitForMultipleObjects(
        length,
        ptr,
        wait_all,
        timeout
      )

      if wait == WAIT_FAILED
        raise SystemCallError.new("WaitForMultipleObjects", FFI.errno)
      end

      # signaled
      if (wait >= WAIT_OBJECT_0) && (wait < WAIT_OBJECT_0 + length)
        return wait - WAIT_OBJECT_0 + 1
      end

      # abandoned mutex - return negative value
      if (wait >= WAIT_ABANDONED) && (wait < WAIT_ABANDONED + length)
        return -wait - WAIT_ABANDONED + 1
      end

      # timed out
      return 0 if wait == WAIT_TIMEOUT

      nil
    end
  end
end

require 'windows/error'
require 'windows/synchronize'
require 'windows/handle'

# The Win32 module serves as a namespace only.
module Win32

   # This is a an abstract base class for IPC related classes, such as
   # Events and Semaphores.
   #
   class Ipc
      include Windows::Error
      include Windows::Synchronize
      include Windows::Handle

      class Error < StandardError; end

      # The version of the win32-ipc library
      VERSION = '0.5.3'

      SIGNALED  = 1
      ABANDONED = -1
      TIMEOUT   = 0
      
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
      #
      def signaled?
         @signaled
      end
      
      # call-seq:
      #    Ipc#wait(timeout)
      #    Ipc#wait(timeout){ block called when signaled }
      #
      # Waits for the calling object to be signaled.  The +timeout+ value is
      # the maximum time to wait, in seconds.  A timeout of 0 returns
      # immediately.
      #
      # Returns SIGNALED (1), ABANDONED (-1) or TIMEOUT (0).  Raises an
      # IPC::Error if the wait fails for some reason.
      # 
      def wait(timeout = INFINITE)
         timeout *= 1000 if timeout && timeout != INFINITE

         wait = WaitForSingleObject(@handle, timeout)
         
         case wait
            when WAIT_FAILED
               raise Error, get_last_error
            when WAIT_OBJECT_0
               @signaled = true
               yield if block_given?
               return SIGNALED
            when WAIT_ABANDONED
               return ABANDONED
            when WAIT_TIMEOUT
               return TIMEOUT
            else
               raise Error, get_last_error
         end
      end
      
      # :call-seq:
      #    IPC#wait_any([ipc_objects], timeout = INFINITE)
      #
      # Waits for at least one of the +ipc_objects+ to be signaled.  The
      # +timeout+ value is maximum time to wait in seconds.  A timeout of 0
      # returns immediately.
      #
      # Returns the index+1 of the object that was signaled.  If multiple
      # objects are signaled, the one with the lowest index is returned.
      # Returns 0 if no objects are signaled.
      # 
      def wait_any(ipc_objects, timeout=INFINITE)
         timeout *= 1000 if timeout && timeout != INFINITE
         wait_for_multiple(ipc_objects, 0, timeout)
      end
      
      # :call-seq:
      #    IPC#wait_all([ipc_objects], timeout = INFINITE)
      #
      # Identical to IPC#wait_any, except that it waits for all +ipc_objects+
      # to be signaled instead of just one.
      #
      # Returns the index of the last object signaled.  If at least one of the
      # objects is an abandoned mutex, the return value is negative.
      # 
      def wait_all(ipc_objects, timeout=INFINITE)
         timeout *= 1000 if timeout && timeout != INFINITE
         wait_for_multiple(ipc_objects, 1, timeout)
      end
      
      private
      
      # Waits until one or all (depending on the value of +wait_all+) of the
      # +ipc_objects+ are in the signaled state or the +timeout+ interval
      # elapses. 
      #
      def wait_for_multiple(ipc_objects, wait_all=0, timeout=INFINITE)
         unless ipc_objects.is_a?(Array)
            msg = 'invalid argument - must be an array of Ipc objects'
            raise TypeError, msg
         end
         
         length = ipc_objects.length
         
         if length == 0
            raise Error, 'no objects to wait for'
         end
         
         handles = ipc_objects.map{ |o| o.handle }

         wait = WaitForMultipleObjects(
            length,
            handles.pack('L*'),
            wait_all,
            timeout
         )
         
         if wait == WAIT_FAILED
            raise Error, get_last_error
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
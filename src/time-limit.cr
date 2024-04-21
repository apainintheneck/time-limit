module TimeLimit(T)
  VERSION = "0.1.0"

  class TimeoutException < Exception
    def initialize(@limit : Time::Span)
      @message = "Reached #{limit} time limit"
    end
  end

  # Spawn a fiber that with an execution time limit.
  #
  # If the block runs successfully, the result is returned.
  # If the block raises an exception, it gets re-raised.
  # If the time limit is reached, a `TimeLimit::TimeoutException` is raised.
  def self.spawn(limit : Time::Span, &block : -> T) : T?
    # Note: We use T? here as the channel type because that allows
    # us to handle blocks with a return type of NoReturn. Otherwise
    # we end up getting type system errors.
    return_channel = Channel(T?).new(capacity: 1)
    exception_channel = Channel(Exception).new(capacity: 1)

    spawn do
      retval = block.call
      return_channel.send(retval)
    rescue ex
      exception_channel.send(ex)
    end

    select
    when retval = return_channel.receive
      retval
    when error = exception_channel.receive
      raise error
    when timeout(limit)
      raise TimeoutException.new(limit: limit)
    end
  end
end

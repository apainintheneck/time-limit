# time-limit

A simple helper to allow you to run logic in a fiber with a time limit. All return values and exceptions are propogated from the spawned fiber back to the original fiber.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     time-limit:
       github: apainintheneck/time-limit
   ```

2. Run `shards install`

## Usage

```crystal
require "time-limit"

# When the calculation completes in the time limit,
# the return value from the block is returned.
result = TimeLimit.spawn(5.seconds) do
  5 * 5 * 5 * 5 * 5
end

puts result # => 3125

# When the calculation raises an error,
# it gets re-raised.
begin
  TimeLimit.spawn(5.seconds) do
    raise ArgumentError.new
  end
rescue ex
  puts ex.class # => ArgumentError
end

# When the calculation goes beyond the time limit,
# a timeout exception is raised.
begin
  TimeLimit.spawn(5.seconds) do
    sleep 10.seconds
  end
rescue ex
  puts ex.class # => TimeLimit::TimeoutException
end
```

See the specs for more examples.

## Development

`crystal spec` is used for testing and `crystal tool format` is used for linting.

## Contributing

1. Fork it (<https://github.com/your-github-user/time-limit/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [apainintheneck](https://github.com/apainintheneck) - creator and maintainer

if defined?(Rails)
  require "tale/engine"
else
  require "tale/version"
  require "tale/chapter"
  require "tale/event"
end

module Tale

end
module Scenarios
  require 'logger'

  Logger = Logger.new(STDOUT)
  Logger.formatter = proc do |severity, datetime, progname, msg|
    "[INFO]: #{msg}\n"
  end
end

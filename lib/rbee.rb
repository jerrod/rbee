module Rbee
  VERSION = "0.1.0"
end

RBEE_ROOT = File.expand_path(File.join(File.dirname(__FILE__)))
puts "RBEE_ROOT: #{RBEE_ROOT}"

EE_ROOT = ENV['RUN_PATH']
puts "EE_ROOT: #{EE_ROOT}"

require File.dirname(__FILE__) + "/config/environment"
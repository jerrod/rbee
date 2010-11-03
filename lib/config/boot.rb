path = "#{RBEE_ROOT}/lib/vendor"

$LOAD_PATH.unshift path
require 'rubygems'  
require 'active_record'  
require 'yaml'  
require 'logger'  
require 'erb'

Dir.glob("#{RBEE_ROOT}/{vendor,models}/*.rb").each {|file| require file }
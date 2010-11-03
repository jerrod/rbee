require File.dirname(__FILE__) + '/boot'

initializer = ExpressionEngine::Initializer.new(ENV['RUN_PATH'])

raise "Unable to connect to DB" unless initializer.configuration_file
configuration = YAML.load_file(initializer.configuration_file)

ActiveRecord::Base.establish_connection(configuration['database'])
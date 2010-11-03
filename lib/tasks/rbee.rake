namespace :ee do
  
  task :environment do 
    path = File.dirname(__FILE__) + "/../"
    require "#{path}/rbee"
  end
  
  task :console do
    path = File.dirname(__FILE__) + "/../"
    libs = "-r irb/completion -r #{path}/rbee"
    puts "Loading Expression Engine console"
    exec "irb #{libs} --simple-prompt"
  end
  
  task :init do
    require "erb"
    require "yaml"
    RBEE_ROOT = File.expand_path(File.join(File.dirname(File.dirname(__FILE__))))
    Dir.glob("#{RBEE_ROOT}/{vendor,models}/*.rb").each {|file| require file }
    
    initializer = ExpressionEngine::Initializer.new(ENV['RUN_PATH'])
    reader = ExpressionEngine::ConfigurationReader.new(initializer.source_configuration_file)
    initializer.configuration = ExpressionEngine::Configuration.new(initializer.root_path, reader)
    initializer.write_configuration
  end
  
  namespace :paths do
    
    task :update => 'ee:environment' do

      Site.find(:all).each do |site|
        site.root_path = ENV['RUN_PATH']
        site.save!
      end
    end
    
  end
  
  namespace :report do
    
    task :templates => 'ee:environment' do 
      Site.find(:all).each do |site|
        puts "Site: #{site.name}"
        site.template_groups.each do |group|
          puts "|-- Template Group: #{group.name}"
          group.templates.each do |template|
            puts "| |-- Template: #{template.name}"
          end
        end
      end
      
    end
    
    task :preferences => 'ee:environment' do
      Site.find(:all).each do |site|
        site.preferences.each do |key, preferences|
          puts "preferences for '#{key}'"
          preferences.each do |key, value|
            puts "  #{key} => #{value}"
          end
        end
      end
      
    end
    
  end
end

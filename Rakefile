require 'rubygems'
require 'rake/gempackagetask'
require 'spec/rake/spectask'


GEM = "rbee"
AUTHOR = "Jerrod Blavos"
EMAIL = "jerrod@impdesigns.com"
HOMEPAGE = "http://www.impdesigns.com"
SUMMARY = "Rbee - A Ruby based toolkit for dealing with expression engine installs."

Dir[File.dirname(__FILE__) + '/support/tasks/*.rake'].each {|file| load file }

task :default => :spec

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = "0.1.0"
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.markdown", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.rubyforge_project = 'impdesigns'
  
  s.executables = ['rbee']
  
  s.add_dependency('activerecord', '>= 2.0.2')
  s.add_dependency('rake', '>= 0.8.1')
  
  s.require_path = 'lib'
  s.files = %w(LICENSE README.markdown Rakefile TODO) + Dir.glob("{lib,specs,vendor}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['-f specdoc']
  t.rcov = true
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{spec.name}-#{spec.version} --no-rdoc --no-ri}
end
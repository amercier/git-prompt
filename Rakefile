require 'rspec/core/rake_task'

task :test do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*.rb'
  end
  Rake::Task['spec'].execute
end

task :default do
  Rake::Task['test'].execute
end

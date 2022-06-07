# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :run do
  exec "./bin/run_app"
end

task :setup do
  ruby 'db/add_transactions.rb'
end
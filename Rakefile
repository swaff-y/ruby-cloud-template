# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'
require_relative 'lib/config'
require_relative 'lib/exceptions/exceptions'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[--display-cop-names --cache false --fail-level C lib]
end

RSpec::Core::RakeTask.new(:spec)

task :coverage do
  pwd = `pwd`.chomp
  cov_hash = JSON.parse(File.read("#{pwd}/coverage/.last_run.json"))
  if cov_hash['result']['line'] < Config.coverage
    raise Exceptions::CoverageError, "Code coverage is not #{Config.coverage}%"
  end
rescue Exceptions::CoverageError => e
  puts e
  exit(1)
end

task default: %i[rubocop spec coverage]
# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'
require_relative 'lib/tasks/coverage'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[--display-cop-names --cache false --fail-level C lib]
end

RSpec::Core::RakeTask.new(:spec)

task :coverage do
  coverage = Tasks::Coverage.new
  coverage.process
end

task default: %i[rubocop spec coverage]
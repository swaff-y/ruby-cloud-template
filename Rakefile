# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'
require_relative 'lib/tasks/coverage'
require_relative 'lib/tasks/deploy'
require_relative 'lib/tasks/aws_login'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[--display-cop-names --cache false --fail-level C lib]
end

RSpec::Core::RakeTask.new(:spec)

task :coverage do
  coverage = Tasks::Coverage.new
  coverage.process
end

task :deploy_dev do
  deploy = Tasks::Deploy.new
  deploy.process('dev')
end

task :deploy_prod do
  deploy = Tasks::Deploy.new
  deploy.process('prod')
end

task :aws_login do
  task = Tasks::AwsLogin.new
  task.process
end

task default: %i[rubocop spec coverage]
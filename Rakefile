# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'
require_relative 'lib/tasks/coverage'
require_relative 'lib/tasks/deploy'
require_relative 'lib/tasks/aws_login'
require_relative 'lib/tasks/postman'
require_relative 'lib/tasks/swagger'
require_relative 'lib/config'

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

task :set_unique_id do
  task = Tasks::Deploy.new
  task.process_unique_id
end

task :postman do
  task = Tasks::Postman.new
  task.process
end

task :swagger do
  task = Tasks::Swagger.new
  Config.logger('info', task.swagger_yaml)
end

task default: %i[rubocop spec coverage]
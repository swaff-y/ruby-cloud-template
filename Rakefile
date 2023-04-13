# frozen_string_literal: true

require 'rubocop/rake_task'
require 'rake'
require 'rspec/core/rake_task'

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = %w[--display-cop-names --cache false --fail-level C lib]
end

RSpec::Core::RakeTask.new(:spec)

# task :coverage do
#   pwd = CheckList::Helpers.system_cmd('pwd').chomp
#   cov_hash = JSON.parse(File.read("#{pwd}/coverage/.last_run.json"))
#   if cov_hash['result']['line'] < CheckList::Config.coverage
#     raise CheckList::Exceptions::CoverageError.new
#   end
# end

# task default: %i[rubocop spec coverage]
task default: %i[rubocop spec]
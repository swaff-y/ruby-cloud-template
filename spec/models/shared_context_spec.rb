RSpec.shared_context 'models' do
  include_context 'event'

  subject(:model) { described_class.new(event, 'context') }
end
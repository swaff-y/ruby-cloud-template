RSpec.shared_context 'controllers' do
  subject(:controller) { described_class.new(event, 'context') }
end
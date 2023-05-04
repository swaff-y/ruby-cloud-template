
require_relative '../event_shared_context'

RSpec.shared_context 'controllers' do
  include_context 'event'

  subject(:controller) { described_class.new(event, 'context') }

  let(:validation_methods) do
    {
      validate_get_by_id: 'validated by id',
      validate_get: 'validated get',
      validate_post: 'validated post',
      validate_put: 'validated put',
      validate_delete: 'validated delete'
    }
  end
  let(:model_methods) do
    {
      find_by_id: 'found by id',
      find: 'found',
      post: 'posted',
      update: 1,
      delete: 'deleted'
    }
  end
  let(:processor_methods) do
    {
      process: 'processed'
    }
  end
end

RSpec.shared_context '200 allow' do
  before do
    allow_any_instance_of(described_class).to receive(:rec_log).and_return('rec log')
    allow(Responses).to receive(:_200).and_return('ok')
  end
end
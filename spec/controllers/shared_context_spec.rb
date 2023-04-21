RSpec.shared_context 'controllers' do
  subject(:controller) { described_class.new(event, 'context') }

  let(:validation_methods) do
    {
      validate_get_by_id: 'validated by id',
      validate_get: 'validated get',
      validate_post: 'validated post'
    }
  end
  let(:model_methods) do
    {
      find_by_id: 'found by id',
      find: 'found',
      post: 'posted'
    }
  end
end

RSpec.shared_context '200 allow' do
  before do
    allow_any_instance_of(described_class).to receive(:rec_log).and_return('rec log')
    allow(Responses).to receive(:_200).and_return('ok')
  end
end

RSpec.shared_context 'Standard error' do
  before do
    allow(validation).to receive(:validate_get).and_raise(StandardError, 'An error')
    allow(Responses).to receive(:_500).and_return('500 error')
  end
end

RSpec.shared_context 'Invalid parameters error' do
  before do
    allow(validation).to receive(:validate_get_by_id).and_raise(Exceptions::InvalidParametersError, 'An error')
    allow(Responses).to receive(:_400).and_return('400 invalid params')
  end
end
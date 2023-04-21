RSpec.shared_context 'mongo_client' do
  let(:client) do
    {
      persons: 'persons'
    }
  end

  before do
    allow(Config).to receive(:mongo_client).and_return(client)
  end
end
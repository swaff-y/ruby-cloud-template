# frozen_string_literal: true

require_relative '../../lib/processors/swagger_processor'

RSpec.describe Processors::SwaggerProcessor do
  subject(:processor) { described_class.new }

  before do
    allow(Tasks::Swagger).to receive(:new).and_return('swagger')
  end

  describe '.initalise' do
    it 'initalises without error' do
      expect{ processor }.not_to raise_error
    end
  end

  describe '#process' do
    it 'returns the model' do
      expect(processor.process).to eq 'swagger'
    end
  end
end
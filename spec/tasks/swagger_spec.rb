# frozen_string_literal: true

require_relative '../../lib/tasks/swagger'

RSpec.describe Tasks::Swagger do
  subject(:swagger) { klass.new }

  let(:klass) { described_class }

  describe '.initalize' do
    before do
      allow(File).to receive(:read).and_return('read file')
      allow(YAML).to receive(:parse).and_return(double(:yaml, to_ruby: {}))
      allow_any_instance_of(klass).to receive(:version).and_return('version')
      allow_any_instance_of(klass).to receive(:info).and_return('info')
      allow_any_instance_of(klass).to receive(:servers).and_return('servers')
      allow_any_instance_of(klass).to receive(:paths).and_return('paths')
      allow_any_instance_of(klass).to receive(:components).and_return('components')
    end

    it 'initalizes without error' do
      expect { klass.new }.not_to raise_error
    end
  end

  describe '#version' do
    let(:expected_result) do
      { 'openapi' => '3.0.0' }
    end

    before do
      allow_any_instance_of(klass).to receive(:info).and_return('info')
      allow_any_instance_of(klass).to receive(:servers).and_return('servers')
      allow_any_instance_of(klass).to receive(:paths).and_return('paths')
      allow_any_instance_of(klass).to receive(:components).and_return('components')
    end

    it 'adds the version to the swagger document' do
      expect(swagger.version).to eq '3.0.0'
      expect(swagger.swagger).to eq expected_result
    end
  end

  describe '#info' do
    let(:expected_result) do
      {
        'description' => 'A ruby template for aws cloud intergration using a mongo db',
        'title' => 'cloud_template_dev',
        'version' => '0.0.19'
      }
    end

    before do
      allow_any_instance_of(klass).to receive(:version).and_return('version')
      allow_any_instance_of(klass).to receive(:servers).and_return('servers')
      allow_any_instance_of(klass).to receive(:paths).and_return('paths')
      allow_any_instance_of(klass).to receive(:components).and_return('components')
    end

    it 'adds the version to the swagger document' do
      expect(swagger.info).to eq expected_result
      expect(swagger.swagger).to eq({ 'info' => expected_result })
    end
  end
end
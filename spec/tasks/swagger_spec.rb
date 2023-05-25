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
      { 'openapi'  =>  '3.0.0' }
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
      expect(swagger.info).to include('description', 'title')
      expect(swagger.swagger['info']).to include('description', 'title')
    end
  end

  describe '#servers' do
    let(:expected_result) do
      [
        {
          'description' => 'Server used for local development when sinatra server is running',
          'url' => 'http://127.0.0.1:4567'
        },
        { 
          'description' => 'Devlopment server',
          'url' => 'https://<unique_id>.execute-api.ap-southeast-2.amazonaws.com/dev-CT-XXX'
        },
        {
          'description' => 'Production server',
          'url' => 'https://4crc3u5fb5.execute-api.ap-southeast-2.amazonaws.com/prod'
        }
      ]
    end

    before do
      allow_any_instance_of(klass).to receive(:version).and_return('version')
      allow_any_instance_of(klass).to receive(:info).and_return('info')
      allow_any_instance_of(klass).to receive(:paths).and_return('paths')
      allow_any_instance_of(klass).to receive(:components).and_return('components')
    end

    it 'adds the version to the swagger document' do
      expect(swagger.servers).to eq expected_result
      expect(swagger.swagger).to eq({ 'servers' => expected_result })
    end
  end

  describe '#components' do
    let(:expected_result) do
      {
        'securitySchemes' => { 
          'ApiKeyAuth' => { 
            'in' => 'header',
            'name' => 'X-API-Key',
            'type' => 'apiKey' 
          }
        }
      }
    end

    before do
      allow_any_instance_of(klass).to receive(:version).and_return('version')
      allow_any_instance_of(klass).to receive(:info).and_return('info')
      allow_any_instance_of(klass).to receive(:paths).and_return('paths')
      allow_any_instance_of(klass).to receive(:servers).and_return('servers')
    end

    it 'adds the version to the swagger document' do
      expect(swagger.components).to eq expected_result
      expect(swagger.swagger).to eq({ 'components' => expected_result })
    end
  end

  describe '#paths' do
    before do
      allow_any_instance_of(klass).to receive(:version).and_return('version')
      allow_any_instance_of(klass).to receive(:info).and_return('info')
      allow_any_instance_of(klass).to receive(:servers).and_return('servers')
      allow_any_instance_of(klass).to receive(:components).and_return('components')
      allow_any_instance_of(klass).to receive(:retrieve_paths).and_return('retrieved paths')
    end

    it 'adds the version to the swagger document' do
      expect(swagger.paths).to eq 'retrieved paths'
      expect(swagger.swagger).to eq({ 'paths' => 'retrieved paths' })
    end
  end

  describe '#retrieve_paths' do
    let(:serverless_hash) do
      {
        'functions' => {
          'test_method' => {
            'events' => [
              'http' => {
                'path' => 'test/path'
              }
            ]
          }
        }
      }
    end

    before do
      allow_any_instance_of(klass).to receive(:send).and_return('sent')
    end

    it 'returns a path hash' do
      swagger.instance_variable_set(:@serverless_yml_hash, serverless_hash)
      expect(swagger.send(:retrieve_paths)).to eq 'sent'
    end
  end
end
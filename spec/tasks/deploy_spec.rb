# frozen_string_literal: true

require_relative '../../lib/tasks/deploy'

RSpec.describe Tasks::Deploy do
  subject(:deploy) { klass.new }

  let(:klass) { described_class }

  before do
    allow(YAML).to receive(:parse).and_return(double(:yaml, to_ruby: {}))
    allow(JSON).to receive(:parse).and_return('json')
  end

  describe '.initalize' do
    context 'when no errors' do
      before do
        allow(File).to receive(:read).and_return('read file')
      end

      it 'initalizes without error' do
        expect { klass.new }.not_to raise_error
      end
    end

    context 'when error' do
      before do
        allow(File).to receive(:read).and_raise(StandardError, 'Error')
        allow(Config).to receive(:logger).and_return('logger')
      end

      it 'initalizes with error' do
        expect { klass.new }.to raise_error SystemExit
      end
    end
  end

  describe '#process' do
    context 'when no error' do
      before do
        allow(File).to receive(:read).and_return('read file')
        allow_any_instance_of(klass).to receive(:process_serverless).and_return('processed sls')
        allow_any_instance_of(klass).to receive(:process_postman).and_return('processed postman')
      end

      it 'processes the correct processes' do
        expect(deploy.process('type')).to eq 'processed postman'
      end
    end

    context 'when error' do
      before do
        allow_any_instance_of(klass).to receive(:process_serverless).and_raise(StandardError, 'an error')
        allow(Config).to receive(:logger).and_return('logger')
      end

      it 'processes the correct processes' do
        expect { deploy.process('type') }.to raise_error SystemExit
      end
    end
  end

  describe '.process_serverless' do
    let(:serverless_hash) do
      {
        'service' => '',
        'provider' => {
          'stage' => '',
          'region' => '',
          'environment' => {
            'STAGE' => '',
            'DB_CONNECTION_STRING' => '',
          }
        },
        'custom' => {
          'databaseUrl' => '',
          'apiKeys' => ''
        }
      }
    end

    before do
      allow(Config).to receive(:mongo_url).and_return('http://fake-url.com')
      allow(Config).to receive(:application_serverless).and_return('serverless-application')
      allow(Config).to receive(:branch_name).and_return('CT-123')
      allow(Config).to receive(:region).and_return('region')
      allow(Config).to receive(:api_keys).and_return('api keys')
      allow(File).to receive(:write).and_return('written file')
    end

    context 'when type dev and hash has provider key' do
      it 'Sets the provider stage to the correct value' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('dev')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['provider']['stage']
        expect(value).to eq 'dev-CT-123'
      end

      it 'Sets the environment stage to correct value' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('dev')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['provider']['environment']['STAGE']
        expect(value).to eq 'dev'
      end
    end

    context 'when type prod and hash has provider key' do
      it 'Sets the provider stage to the correct value' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('prod')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['provider']['stage']
        expect(value).to eq 'prod'
      end

      it 'Sets the environment stage to correct value' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('prod')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['provider']['environment']['STAGE']
        expect(value).to eq 'prod'
      end
    end

    context 'when unless db_connection string is nil and hash has a provider key' do
      it 'sets the correct value for environment.DB_CONNECTION_STRING' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('dev')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['provider']['environment']['DB_CONNECTION_STRING']
        expect(value).to eq 'http://fake-url.com'
      end
    end

    context 'when hash has provider key' do
      it 'sets the provider.region' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('dev')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['provider']['region']
        expect(value).to eq 'region'
      end
    end

    context 'when unless db_connection string is nil and hash has a custom key' do
      it 'sets the custom.databaseUrl' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('dev')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['custom']['databaseUrl']
        expect(value).to eq 'http://fake-url.com'
      end
    end

    context 'when hash has custom key' do
      it 'sets the api key' do
        deploy.instance_variable_set(:@serverless_yml_hash, serverless_hash)
        deploy.process_serverless('dev')
        value = deploy.instance_variable_get(:@serverless_yml_hash)['custom']['apiKeys']
        expect(value).to eq 'api keys'
      end
    end
  end

  describe '.process_postman' do
    let(:postman_json) do
      {
        'auth' => {
          'apikey' => [
            'key' => 'value'
          ]
        },
        'variable' => [
          'key' => 'stage'
        ],
        'item' => [
          {
            'name' => 'GET /status',
            'west' => 'wvalue'
          }
        ]
      }
    end

    before do
      allow(File).to receive(:write).and_return('written file')
      allow_any_instance_of(klass).to receive(:process_status_endpoint).and_return('processed')
    end

    context 'when key nil' do
      before do
        allow(ENV).to receive(:fetch).and_return(nil)
      end

      it 'raises the correct error' do
        deploy.instance_variable_set(:@postman_json_hash, nil)
        expect {deploy.process_postman}.to raise_error StandardError, 'No api key variables set'
      end
    end

    context 'when auth.apikey' do
      before do
        allow(ENV).to receive(:fetch).and_return('F@K3k3Y')
      end

      it 'adds the correct value to the key' do
        deploy.instance_variable_set(:@postman_json_hash, postman_json)
        deploy.process_postman
        postman_hash = deploy.instance_variable_get(:@postman_json_hash)
        expect(postman_hash['auth']['apikey'][0]['value']).to eq 'F@K3k3Y'   
      end
    end

    context 'when prod' do
      before do
        allow(Config).to receive(:prod?).and_return(true)
        allow(ENV).to receive(:fetch).and_return('F@K3k3Y')
      end

      it 'sets the correct value' do
        deploy.instance_variable_set(:@postman_json_hash, postman_json)
        deploy.process_postman
        postman_hash = deploy.instance_variable_get(:@postman_json_hash)
        expect(postman_hash['variable'][0]['value']).to eq 'prod' 
      end
    end

    context 'when not prod' do
      before do
        allow(Config).to receive(:prod?).and_return(false)
        allow(Config).to receive(:branch_name).and_return('branch-name')
        allow(ENV).to receive(:fetch).and_return('F@K3k3Y')
      end

      it 'sets the correct value' do
        deploy.instance_variable_set(:@postman_json_hash, postman_json)
        deploy.process_postman
        postman_hash = deploy.instance_variable_get(:@postman_json_hash)
        expect(postman_hash['variable'][0]['value']).to eq 'dev-branch-name' 
      end
    end

    context 'when status endpoint' do
      before do
        allow(Config).to receive(:prod?).and_return(false)
        allow(Config).to receive(:branch_name).and_return('branch-name')
        allow(ENV).to receive(:fetch).and_return('F@K3k3Y')
      end

      it 'sets the correct value' do
        deploy.instance_variable_set(:@postman_json_hash, postman_json)
        deploy.process_postman
        postman_hash = deploy.instance_variable_get(:@postman_json_hash)
        expect(postman_hash['item'][0]['west']).to eq 'wvalue' 
      end
    end
  end

  describe '.process_unique_id' do
    let(:postman_json) do
      {
        'variable' => [
          'key' => 'unique_id',
          'value' => ''
        ]
      }
    end
    
    before do
      allow(File).to receive(:write).and_return('written file')
      allow(ENV).to receive(:fetch).and_return('unique id')
    end 

    it 'sets the correct value' do
      deploy.instance_variable_set(:@postman_json_hash, postman_json)
      deploy.process_unique_id
      postman_hash = deploy.instance_variable_get(:@postman_json_hash)
      expect(postman_hash['variable'][0]['value']).to eq 'unique id' 
    end
  end

  describe '.process_status_endpoint' do
    let(:status_endpoint) do
      {
        'event' => [{
          'script' => {
            'exec' => [
              '$DATABASE'
            ]
          }
        }]
      }
    end

    before do
      allow(File).to receive(:write).and_return('written file')
      allow(ENV).to receive(:fetch).and_return('unique id')
      allow(Config).to receive(:application).and_return('an application')
    end 

    it 'sets the correct value' do
      deploy.instance_variable_set(:@status_endpoint, status_endpoint)
      expect(deploy.process_status_endpoint).to eq(["an application"])
    end
  end
end
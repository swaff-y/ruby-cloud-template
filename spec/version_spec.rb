# frozen_string_literal: true

require_relative '../lib/version'

RSpec.describe VERSION do
  let(:readme) { "[changelog-badge]: https://img.shields.io/badge/changelog%20version-#{VERSION}-blue.svg" }
  let(:changelog) { "## [#{VERSION}]\n" }
  
  describe 'version' do
    it 'Has the correct version' do
      expect(VERSION).not_to be_nil
    end
  end

  describe 'Readme' do
    it 'Has the correct version' do
      lines = File.readlines(File.join(__dir__, '..', 'README.md'))
      expect(lines.include?("[changelog-badge]: https://img.shields.io/badge/changelog%20version-0.1.1-blue.svg")).to be true
    end
  end

  describe 'Changelog' do
    it 'Has the correct version' do
      lines = File.readlines(File.join(__dir__, '..', 'CHANGELOG.md'))
      expect(lines.include?(changelog)).to be true
    end
  end
end

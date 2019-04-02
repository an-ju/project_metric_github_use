RSpec.describe ProjectMetricGithubUse do
  context 'meta data' do
    it "has a version number" do
      expect(ProjectMetricGithubUse::VERSION).not_to be nil
    end
  end

  context 'image and score' do
    subject(:metric) do
      described_class.new github_project: 'https://github.com/an-ju/projectscope', github_token: 'test token'
    end

    before :each do
      client = double('client')
      events_raw = double('raw events')

      allow(Octokit::Client).to receive(:new).and_return(client)
      allow(client).to receive(:auto_paginate=)
      allow(client).to receive(:repository_events).with('an-ju/projectscope').and_return(events_raw)
      allow(client).to receive(:commit) { JSON.parse(File.read('spec/data/github_commit.json')) }
      allow(events_raw).to receive(:select) { JSON.parse(File.read('spec/data/raw_data_github_events.json'))['github_events'] }
    end

    it 'should parse raw data correctly' do
      expect(metric.instance_variable_get(:@github_events)).not_to be_nil
    end

    it 'should give the right score' do
      expect(metric.score).to be > 0
    end

    it 'should set image data' do
      expect(metric.image).to have_key(:data)
    end

    it 'should have the right image content' do
      image = metric.image
      expect(image[:data][:commit_issues]).not_to be_empty
      expect(image[:data][:branch_issues]).not_to be_empty
    end
  end

  context 'data generator' do
    it 'should generate a list of fake metrics' do
      expect(described_class.fake_data.length).to eql(3)
      expect(described_class.fake_data.first).to have_key(:image)
      expect(described_class.fake_data.first).to have_key(:score)
    end

    it 'should set image contents correctly' do
      image = described_class.fake_data.first[:image]
      expect(image[:data][:commit_issues]).not_to be_empty
      expect(image[:data][:branch_issues]).not_to be_empty
    end
  end
end

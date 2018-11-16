RSpec.describe ProjectMetricGithubUse do
  context 'meta data' do
    it "has a version number" do
      expect(ProjectMetricGithubUse::VERSION).not_to be nil
    end
  end

  context 'image and score' do
    subject(:metric) do
      credentials = {github_project: 'https://github.com/an-ju/teamscope', github_token: 'test token'}
      raw_data = File.read 'spec/data/raw_data_github_events.json'
      described_class.new(credentials, raw_data)
    end

    it 'should parse raw data correctly' do
      expect(metric.instance_variable_get(:@events)).not_to be_nil
    end

    it 'should give the right score' do
      expect(metric.score).to be > 0
    end

    it 'should set image data' do
      expect(JSON.parse(metric.image)).to have_key('data')
    end

    it 'should have the right image content' do
      image = JSON.parse(metric.image)
      expect(image['data']['commit_issues']).not_to be_empty
      expect(image['data']['branch_issues']).not_to be_empty
    end
  end

  context 'data generator' do
    it 'should generate a list of fake metrics' do
      expect(described_class.fake_data.length).to eql(3)
      expect(described_class.fake_data.first).to have_key(:image)
      expect(described_class.fake_data.first).to have_key(:score)
    end

    it 'should set image contents correctly' do
      image = JSON.parse(described_class.fake_data.first[:image])
      expect(image['data']['commit_issues']).not_to be_empty
      expect(image['data']['branch_issues']).not_to be_empty
    end
  end
end

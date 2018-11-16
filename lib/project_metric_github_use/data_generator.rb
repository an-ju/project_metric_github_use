class ProjectMetricGithubUse
  def self.fake_data
    [fake_metric(3,3), fake_metric(2, 0), fake_metric(0, 0)]
  end

  def self.fake_metric(commits, branches)
    {
        score: commits*2 + branches*2,
        image: {
            chartType: 'github_use',
            data: {
                commit_issues: Array.new(commits) { commit_issue },
                branch_issues: Array.new(branches) { branch_issue }
            }
        }.to_json
    }
  end

  def self.branch_issue
    {
        issue: 'Branch name \'travis_ci_gem\' does not have story ID.',
        severity: 2,
        payload: {:id=>"8558626905", :type=>"CreateEvent", :actor=>{:id=>5564756, :login=>"an-ju", :display_login=>"an-ju", :gravatar_id=>"", :url=>"https://api.github.com/users/an-ju", :avatar_url=>"https://avatars.githubusercontent.com/u/5564756?"}, :repo=>{:id=>72873514, :name=>"an-ju/projectscope", :url=>"https://api.github.com/repos/an-ju/projectscope"}, :payload=>{:ref=>"travis_ci_gem", :ref_type=>"branch", :master_branch=>"develop", :description=>"ProjectScope developed for CS169 at UC Berkeley.", :pusher_type=>"user"}, :public=>true, :created_at=>'2018-11-08 18:49:35 UTC' }
    }
  end

  def self.commit_issue
    {
        issue: 'Commit message \'update the gem\' does not have story ID.',
        severity: 2,
        payload: {:sha=>"5f898b50f9f7661eab85bf127c2891fe28d4ab75", :author=>{:email=>"an_ju@berkeley.edu", :name=>"an-ju"}, :message=>"added heroku status gem.", :distinct=>true, :url=>"https://api.github.com/repos/an-ju/projectscope/commits/5f898b50f9f7661eab85bf127c2891fe28d4ab75"}
    }
  end
end
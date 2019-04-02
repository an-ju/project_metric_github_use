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
        }
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
        issue: %q{Commit <a href="https://github.com/octocat/Hello-World/commit/6dcb09b5b57875f334f61aebed695e2e4193db5e">123456</a> is too large.},
        severity: 2,
        payload: '
{   "commit": {
    "url": "https://api.github.com/repos/octocat/Hello-World/git/commits/6dcb09b5b57875f334f61aebed695e2e4193db5e",
    "author": {
      "name": "Monalisa Octocat",
      "email": "support@github.com",
      "date": "2011-04-14T16:00:49Z"
    },
    "committer": {
      "name": "Monalisa Octocat",
      "email": "support@github.com",
      "date": "2011-04-14T16:00:49Z"
    },
    "message": "Fix all the bugs",
    "tree": {
      "url": "https://api.github.com/repos/octocat/Hello-World/tree/6dcb09b5b57875f334f61aebed695e2e4193db5e",
      "sha": "6dcb09b5b57875f334f61aebed695e2e4193db5e"
    },
    "comment_count": 0,
    "verification": {
      "verified": false,
      "reason": "unsigned",
      "signature": null,
      "payload": null
    }
  }'
    }
  end
end
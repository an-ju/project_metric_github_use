require "project_metric_github_use/version"
require 'project_metric_github_use/data_generator'
require 'octokit'
require 'json'
require 'date'
require 'time'

class ProjectMetricGithubUse
  def initialize(credentials, raw_data = nil)
    @project_url = credentials[:github_project]
    @identifier = URI.parse(@project_url).path[1..-1]
    @client = Octokit::Client.new access_token: credentials[:github_access_token]
    @client.auto_paginate = true
    @main_branch = credentials[:github_main_branch]

    self.raw_data = raw_data if raw_data
  end

  def refresh
    set_events
    @raw_data = { events: @events.map(&:to_h) }.to_json
  end

  def raw_data=(new_data)
    @raw_data = new_data
    @events = JSON.parse(new_data, symbolize_names: true)[:events]
  end

  def score
    refresh unless @raw_data
    (commit_issues+branch_issues).inject(0) { |sum, val| sum + val[:severity] }
  end

  def image
    refresh unless @raw_data
    @image ||= { chartType: 'github_use',
                 data: { commit_issues: commit_issues,
                         branch_issues: branch_issues }}.to_json
  end

  def self.credentials
    %I[github_project github_access_token github_main_branch]
  end

  private

  def set_events
    # Events in the past three days
    @events = @client.repository_events(@identifier)
                  .select { |event| event[:created_at] > (Time.now - 3*24*60*60) }
  end

  def commit_issues
    commits = @events.select { |event| event[:type].eql?('PushEvent') }.flat_map { |event| event[:payload][:commits] }
    commits.select { |cmit| cmit[:distinct] && missing_template?(cmit) }
           .map { |cmit| {issue: "Commit message '#{cmit[:message]}' does not have story ID.", severity: 2, payload: cmit } }
  end

  def branch_issues
    branches = @events.select { |event| event[:type].eql?('CreateEvent') && event[:payload][:ref_type].eql?('branch') }
    branches.select { |branch| wrong_branch_name? branch[:payload] }
            .map { |branch| {issue: "Branch name '#{branch[:payload][:ref]}' does not have story ID.", severity: 2, payload: branch } }
  end

  # def pr_issues
  #   pull_requests = @events.select { |event| event[:type].eql? 'PullRequestEvent' }
  #   short_close_time(pull_requests)
  # end

  def missing_template?(cmit)
    return false if cmit[:message].start_with? 'Merge'
    /^\[\d+\]/.match(cmit[:message]).nil? ? true : false
  end

  def wrong_branch_name?(branch)
    /^\d+/.match(branch[:ref]).nil? ? true : false
  end

  # def short_close_time(pull_requests)
  #   closed_time = {}
  #   opened_time = {}
  #   pull_requests.each do |pr|
  #     action_type = pr[:payload][:action]
  #     pr_number = pr[:payload][:number]
  #     if action_type.eql? 'opened'
  #       opened_time[pr_number] = pr[:created_at]
  #     elsif action_type.eql? 'closed' && pr[:payload][:pull_request][:merged]
  #       closed_time[pr_number] = [pr, pr[:created_at]]
  #     end
  #   end
  #   issues = []
  #   closed_time.each do |pr_number, pr, ctime|
  #     if opened_time.has_key? pr_number
  #       close_time = ctime - opened_time[pr_number]
  #       if close_time < 60*60
  #         issues.push(issue: "Pull request #{pr_number} closed in #{closed_time/60} minutes.", severity: 2, payload: pr)
  #       end
  #     end
  #   end
  #   issues
  # end


end

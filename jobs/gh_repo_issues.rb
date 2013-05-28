#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

# Config
# ------
github_username = 'wiredcraft'

# Last issue for this repo 
repo_names = ['embarq', 'gwilcher', 'hnshanghai']

# show this many issues per repo
max_length = 1

# order by (false for default github)
ordered = false

# list repos
# /orgs/wiredcraft/repos

# list issues for repo
# "/repos/#{github_username}/#{repo_name}/issues"

# curl -H "Authorization: token cf993c25daf7d73be73023cc088636bf930d8a0c" \https://api.github.com/path/to/info

SCHEDULER.every '3m', :first_in => 0 do |job|
  repos_issues = Array.new

  i = 0
  while i < repo_names.length
    rpo = repo_names[i]

    uri = uri = URI.parse("https://api.github.com/repos/#{github_username}/#{rpo}/issues")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    headers = { "Authorization" => "token cf993c25daf7d73be73023cc088636bf930d8a0c" }
    request = Net::HTTP::Get.new(uri.request_uri, headers)
    response = http.request(request)
    data = JSON.parse(response.body)


    if data
      data.each do |repo|
        repos_issues.push({
        title: "#{rpo}",
        issue: repo['title'],
        assignee: repo['user']['login'],
        body: repo['body']
      })
      end
    end

    i += 1
  end

  send_event('gh_repo_issues', { comments: repos_issues })
end
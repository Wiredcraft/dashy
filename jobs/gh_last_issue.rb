#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

# Config
# ------
github_username = 'wiredcraft'

# List issues for this repo 
repo_name = 'embarq'

# show this many issues
max_length = 1

# order by (false for default github)
ordered = false

# list repos
# /orgs/wiredcraft/repos

# list issues for repo
# "/repos/#{github_username}/#{repo_name}/issues"

# curl -H "Authorization: token cf993c25daf7d73be73023cc088636bf930d8a0c" \https://api.github.com/path/to/info

SCHEDULER.every '3m', :first_in => 0 do |job|
  uri = uri = URI.parse("https://api.github.com/repos/#{github_username}/#{repo_name}/issues")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  headers = { "Authorization" => "token cf993c25daf7d73be73023cc088636bf930d8a0c" }
  request = Net::HTTP::Get.new(uri.request_uri, headers)
  response = http.request(request)

  data = JSON.parse(response.body)

  if response.code != "200"
    puts "github api error (status-code: #{response.code})\n#{response.body}"
  else
    repos_issues = Array.new
    data.each do |repo|
      repos_issues.push({
      issue: repo['title'],
      assignee: repo['user']['login'],
      comment: repo['body']
    })
    end

    send_event('gh_last_issue', { items: repos_issues.slice(0, max_length) })

  end

end
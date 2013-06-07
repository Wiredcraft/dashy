#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

# Config
# ------
github_username = 'wiredcraft'

# show this many issues
max_length = 12

# order by (false for default github)
ordered = true

# list repos
# /orgs/wiredcraft/repos

# list issues for repo
# "/repos/#{github_username}/#{repo_name}/issues"

# curl -H "Authorization: token cf993c25daf7d73be73023cc088636bf930d8a0c" \https://api.github.com/path/to/info

SCHEDULER.every '3m', :first_in => 0 do |job|
  uri = uri = URI.parse("https://api.github.com/orgs/#{github_username}/repos?per_page=100")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  headers = { "Authorization" => "token c2ea629f0a4619abd039df7e07ecc5bcb7e57917" }
  request = Net::HTTP::Get.new(uri.request_uri, headers)
  response = http.request(request)

  data = JSON.parse(response.body)

  if response.code != "200"
    puts "github api error (status-code: #{response.code})\n#{response.body}"
  else
    repos_issues = Array.new
    data.each do |repo|
      repos_issues.push({
      label: repo['name'],
      value: repo['open_issues_count']
    })
    end

    if ordered
      repos_issues = repos_issues.sort_by { |obj| -obj[:value] }
    end

    send_event('github_issues', { items: repos_issues.slice(0, max_length) })

  end

end
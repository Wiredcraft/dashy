#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

# Config
# ------
github_username = 'wiredcraft'

github_reponame = 'dashboard'

# order by (false for default github)
ordered = true

SCHEDULER.every '3m', :first_in => 0 do |job|
  uri = uri = URI.parse("https://api.github.com/repos/#{github_username}/#{github_reponame}/milestones")
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
      title: repo['title'],
      number: repo['number'],
      due_on: repo['due_on'],
      open_issues: repo['open_issues'],
      closed_issues: repo['closed_issues']
    })
    end

    if ordered
      repos_issues = repos_issues.sort_by { |obj| -obj[:number] }
    end

    send_event('gh_milestone', { values: repos_issues.slice(0, 1) })

  end

end
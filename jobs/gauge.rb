#!/usr/bin/env ruby
require 'net/http'
require 'json'
require 'uri'

# Config
# ------
gauges_token = 'fb42a9864d5b86f982629fb740f1114f'

# Guages for token
# ----------------
# [0] = devo.ps
# [1] = ShanghaiHN.org
# [2] = shanghaios.org
# [3] = teddy.fr
# [4] = TheWineDrop.com
use = 0

# order by (false for default github)
ordered = true

SCHEDULER.every '5m', :first_in => 0 do |job|
  # last_count = current_count

  uri = uri = URI.parse("https://secure.gaug.es/gauges")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  headers = { "X-Gauges-Token" => "#{gauges_token}" }
  request = Net::HTTP::Get.new(uri.request_uri, headers)
  response = http.request(request)

  data = JSON.parse(response.body)

  if response.code != "200"
    puts "gaug.es api error (status-code: #{response.code})\n#{response.body}"
  else

    gauge = data['gauges'][use]
    gtitle = gauge['title']
    current_count = gauge['today']['views']
    last_count = gauge['yesterday']['views']

    send_event('gauge', { current: current_count, last: last_count, title: gtitle })
  end
end

require 'net/http'
require 'net/https'
require 'cgi'
require 'json'

require 'pp'

$client = nil
$cookies = nil

def login(username, password)
  $client = Net::HTTP.new 'members.iracing.com', 80
  # $client.set_debug_output $stderr
  res = $client.post('/jforum/Login',
    "username=#{CGI::escape username}&password=#{CGI::escape password}")
  if res['Location'] and res['Location'] == 'http://members.iracing.com/jforum'
    $cookies = res.to_hash['set-cookie']&.collect{|ea| ea[/^.*?;/]}.join
  else
    $client = nil
  end
  $client != nil
end

def get_event_results(subsessionID)
  res = $client.post('/membersite/member/GetSubsessionResults',
    "subsessionID=#{subsessionID}", {'Cookie' => $cookies})
  JSON.parse res.body
end

def get_races(seasonid, raceweek)
  res = $client.post('/memberstats/member/GetSeriesRaceResults',
    "seasonid=#{seasonid}&raceweek=#{raceweek}&invokedBy=SeriesRaceResults",
      {'Cookie' => $cookies})
  JSON.parse res.body
end

# ugly hack, but better than the rest of the APIs
def get_member_brief_stats(custid)
  res = $client.get("/membersite/member/CareerStats.do?custid=#{custid}", {'Cookie' => $cookies})
  start = res.body.index('buf = \'{"memberSince"') + 7
  length = res.body.index("MemberProfile.driver = extractJSON") - 3 - start
  data = res.body[start, length]
  JSON.parse data
end



require 'net/http'
require 'net/https'
require 'cgi'
require 'json'

require 'pp'

$client = nil
$cookies = nil
$headers = nil

def login(username, password)
  $client = Net::HTTP.new 'members.iracing.com', 80
  # $client.set_debug_output $stderr
  res = $client.post('/jforum/Login',
    "username=#{CGI::escape username}&password=#{CGI::escape password}")
  if res['Location'] and res['Location'] == 'http://members.iracing.com/jforum'
    $cookies = res.to_hash['set-cookie']&.collect{|ea| ea[/^.*?;/]}.join
    $headers = { 'Cookie' => $cookies }
  else
    $client = nil
  end
  $client != nil
end

#TODO document the object format
def get_event_results(subsessionID)
  res = $client.post('/membersite/member/GetSubsessionResults',
    "subsessionID=#{subsessionID}", $headers)
  JSON.parse res.body
end

#TODO document the object format
def get_races(seasonid, raceweek)
  res = $client.post('/memberstats/member/GetSeriesRaceResults',
    "seasonid=#{seasonid}&raceweek=#{raceweek}&invokedBy=SeriesRaceResults",
      $headers)
  JSON.parse res.body
end

def get_official_races(seasonid)
  (0..11).to_a.map do |w|
    get_races(seasonid,w)["d"].select do |r| r["6"] == 1 end
  end.reduce(:concat)
end

# ugly hack, but better than the rest of the APIs
def get_member_brief_stats(custid)
  res = $client.get("/membersite/member/CareerStats.do?custid=#{custid}", $headers)
  start = res.body.index('buf = \'{"memberSince"') + 7
  length = res.body.index("MemberProfile.driver = extractJSON") - 3 - start
  data = res.body[start, length]
  JSON.parse data
end

def get_career_stats(custid)
  res = $client.get("/memberstats/member/GetCareerStats?custid=#{custid}", $headers)
  JSON.parse res.body
end

def get_chart_data(custId, catId, chartType)
  res = $client.get("/memberstats/member/GetChartData?custId=#{custId}&catId=#{catId}&chartType=#{chartType}", $headers)
  JSON.parse res.body
end

def get_irating(custId, catId)
  get_chart_data(custId, catId, 1)[-1][1]
end

$licenses = {
  1 => 'R',
  2 => 'D',
  3 => 'C',
  4 => 'B',
  5 => 'A',
  # no 6
  7 => 'P'
}

def get_license_class(custId, catId)
  v = get_chart_data(custId, catId, 3)[-1][1]
  "#{$licenses[v/1000]} #{'%.2f' % ((v%1000)/100.0)}"
end

def get_all_seasons()
  res = $client.get("/membersite/member/GetSeasons?onlyActive=0&fields=year,quarter,seriesshortname,seriesid,active,catid,licenseeligible,islite,carclasses,tracks,start,end,cars,raceweek,category,serieslicgroupid,carid,seasonid,seriesid", $headers);
  JSON.parse res.body
end

def send_private_message(toUsername, subject, message)
  res = $client.post("/jforum/jforum.page",
    "action=sendSave&module=pm&toUsername=#{CGI::escape toUsername}&subject=#{CGI::escape subject}&message=#{CGI::escape message}", $headers)
end


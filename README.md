iRacing http data for ruby
==========================

# Usage

`login(username, password)`: execute the login of the client, REQUIRED step; this don't work anymore, see `autologin`

`autologin`: read cookies from auth.txt and execute login from existing cookies

`get_event_results(subsessionID)`: get the stats for a given subsessionID

`get_races(seasonID, week)`: list the races happened in a given week for a given season

`get_member_brief_stats(custId)`: fetch the stats from the member page; deprecated

`get_career_stats(custid)`: get the driver career stats, number of wins, starts, etc...

`get_chart_data(custId, catId, chartType)`: fetch the data points for the graph seen in the member stats page; catId = [1,2,3,4] for [Oval, Road, Dirt+Oval, Dirt+Road]

`get_irating(custId, catId)`: get the current driver irating (catId, see `get_chart_data`)

`get_license_class(custId, catId)`: get the text representing the license class for the catId selected

`get_official_races(seasonId)`: list the official races for a given season, calling 12 times get_races, and filtering the results.

`get_all_seasons()`: list all the seasons ever run or currently running on iRacing

`send_private_message(toUsername, subject, message)`: send a private message on the iRacing forum

The data format isn't documented since it isn't an official API.

Rate limit the requests to avoid problems to the iracing servers.


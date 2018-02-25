iRacing http data for ruby
==========================

# Usage

`login(username, password)`: execute the login of the client, REQUIRED step

`get_event_results(subsessionID)`: get the stats for a given subsessionID

`get_races(seasonID, week)`: list the races happened in a given week for a given season

`get_member_brief_stats(custId)`: fetch the stats from the member page

The data format isn't documented since it isn't an official API.

Rate limit the requests to avoid problems to the iracing servers.


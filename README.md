Spoton Event Calendar -- technical challenge
===

Summary:  This is a small web program that scrapes events from 5 different websites (Stanford event calendar, eventbrite, SF Moma, Meetup.com, and SF Fun Cheap), and lists them in an easy-to-parse format with a web front-end.

Caveats:  Some functionality is incomplete with regards to each event source.  For instance, date parsing only works on the Eventbrite site.  External links work on every source *except* for Eventbrite (they hide hrefs for individual event links).

How to run:  This project uses Bundler(Rails), npm, and bower as dependencies.  To download dependencies, run the following commands:
  $ bundle
  $ bower install

To run the server, simply invoke:
  $ rails s

Other Notes:  In a real production app, testing would be crucial to ensure each individual scraper doesn't break when the client changes their markup.  In addition, some logic in the "scrape" function would likely best live within each event source sub-type.
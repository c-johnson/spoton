require 'unirest'
require 'pry-byebug'
require 'nokogiri'

class HomeController < ApplicationController
  def index

  end

  def events
    events = scrape(map[params['src'].to_sym])

    respond_to do |format|
      format.json { render json: events}
    end
  end

  private

  def map
    {
      stanford: {
        url: "http://events.stanford.edu",
        root_id: "#main-content",
        li_id: ".postcard-link",
        title_id: ".postcard-text h3",
        date_id: ".postcard-text strong",
      },
      stanford_oct: {
        url: "http://events.stanford.edu/2014/October/1/",
        root_id: "#main-content",
        li_id: ".postcard-link",
        title_id: ".postcard-text h3",
        date_id: ".postcard-text strong",
      },
      eventbrite: {
        url: "https://www.eventbrite.com/",
        root_id: '.g-grid.l-padded-v-bottom-5',
        li_id: '.g-cell.l-padded-v',
        title_id: 'h4',
        date_id: '.event-poster__date'
      },
      sf_moma: {
        url: "http://www.sfmoma.org/",
        root_id: '.interim-content-modules',
        li_id: '.mod.third',
        title_id: '.title',
        date_id: '.date'
      },
      meetup: {
        url: "http://www.meetup.com/find/events/?allMeetups=true&radius=5&userFreeform=Redwood+City%2C+CA&mcId=z94061&mcName=Redwood+City%2C+CA",
        root_id: '.search-result.search-list',
        li_id: '.event-listing',
        title_id: '[itemprop="summary"]',
        date_id: '[itemprop="startDate"]'
      }
    }
  end

  # Output:  
  # => Date
  # => Title
  # => Time
  def scrape(ids)
    response = Unirest.get(ids[:url])
    html_doc = Nokogiri::HTML(response.body)
    html_arr = html_doc.css(ids[:root_id]).css(ids[:li_id])

    # binding.pry if ids[:url] == "http://www.sfmoma.org/"

    return_hash = html_arr.map do |item|
      # binding.pry if ids[:url] == "http://www.sfmoma.org/"
      title = item.css(ids[:title_id]).try(:text).try(:strip) || ""
      date = item.css(ids[:date_id]).try(:text).try(:strip) || ""
      if title != ""
        {
          title: title,
          date: date,
        }
      else
        nil
      end
    end.compact
  end
end

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
        link_id: "root",
        link_root: "http://events.stanford.edu",
        title_id: ".postcard-text h3",
        date_id: ".postcard-text strong",
      },
      stanford_oct: {
        url: "http://events.stanford.edu/2014/October/1/",
        root_id: "#main-content",
        li_id: ".postcard-link",
        link_id: "root",
        link_root: "http://events.stanford.edu",
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
        link_id: ".mod-link",
        link_root: "http://sfmoma.org",
        link_attr: "data-url",
        title_id: '.title',
        date_id: '.date'
      },
      meetup: {
        url: "http://www.meetup.com/find/events/?allMeetups=true&radius=5&userFreeform=Redwood+City%2C+CA&mcId=z94061&mcName=Redwood+City%2C+CA",
        root_id: '.search-result.search-list',
        li_id: '.event-listing',
        link_id: ".event-title",
        title_id: '[itemprop="summary"]',
        date_id: '[itemprop="startDate"]'
      },
      sf_funcheap: {
        url: "http://sf.funcheap.com/",
        root_id: '.upcoming-calendar',
        li_id: 'tr',
        link_id: "a",
        title_id: 'a',
        date_id: '[style="width:66px"]'
      }
    }
  end

  def extract_link

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
      # binding.pry if ids[:url] == "http://events.stanford.edu/2014/October/1/"

      title = item.css(ids[:title_id]).try(:text).try(:strip) || ""
      date_str = item.css(ids[:date_id]).try(:text).try(:strip) || ""

      if ids[:link_id] == "root"
        link_str = item.attributes["href"].value || ""  
      elsif ids[:link_id] != nil
        link_attr = ids[:link_attr] || "href"
        link_node = item.css(ids[:link_id])
        if !link_node.empty?
          link_str = item.css(ids[:link_id])[0].attributes[link_attr].value || ""  
        end
      end
      
      if ids[:link_root] != nil
        link_str = URI.join(ids[:link_root], link_str).to_s
      end

      if title != ""
        {
          title: title,
          date: date_str,
          link: link_str || ""
        }
      else
        nil
      end
    end.compact
  end
end

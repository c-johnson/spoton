require 'unirest'
require 'pry-byebug'
require 'nokogiri'

class HomeController < ApplicationController
  def index

    map = {
      stanford: {
        url: "http://events.stanford.edu/2014/October/1/",
        root_id: "#main-content",
        li_id: ".postcard-link",
        title_id: ".postcard-text h3",
        date_id: ".postcard-text strong",
      }
    }

    scrape(map[:stanford])
  end

  private

  # Output:  
  # => Date
  # => Title
  # => Time
  def scrape(ids)
    response = Unirest.get(ids[:url])
    html_doc = Nokogiri::HTML(response.body)
    html_arr = html_doc.css(ids[:root_id]).css(ids[:li_id])

    # binding.pry

    return_hash = html_arr.map do |item|
      {
        title: item.css(ids[:title_id])[0].text.strip,
        date: item.css(ids[:date_id])[0].text.strip,
      }
    end

    # binding.pry
  end

end

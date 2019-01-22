require 'open-uri'
require 'nokogiri'
require 'pry-byebug'

PATTERN = /\/title\/tt\d{7}\//
BASE_URL = "http://www.imdb.com"

def fetch_movies_url
  html_doc = Nokogiri::HTML(open('https://www.imdb.com/chart/top').read)
  html_doc.search('.titleColumn a').take(5).map do |link|
    "#{BASE_URL}#{link.attributes['href'].value.match(/\/title\/tt\d{7}\//).to_s}"
  end
end

def scrape_movie(movie_url)
  html_doc = Nokogiri::HTML(open(movie_url).read)

  title_match = html_doc.at('.title_wrapper h1').text.strip.match(/(?<title>.*)\((?<year>\d{4})\)/)

  title = title_match[:title].tr("\u00A0", '') # trimming non breaking space
  year = title_match[:year].to_i
  storyline = html_doc.at('.summary_text').text.strip
  director = html_doc.at('.credit_summary_item a').text.strip
  cast = html_doc.search('.cast_list tr td:nth-child(2)').take(3).map do |element|
    element.text.strip
  end

  {
    cast: cast,
    director: director,
    storyline: storyline,
    title: title,
    year: year
  }
end

def save_top_movies_to_yaml(yaml_file)
  top_movies = fetch_movies_url.map { |movie_url| scrape_movie(movie_url) }

  puts "Saving top movies in #{yaml_file}..."
  File.open(yaml_file, "w") do |f|
    f.write(top_movies.to_yaml)
  end
  puts 'Done!'
end

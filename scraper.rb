require 'open-uri'
require 'nokogiri'
require 'pry-byebug'
require 'yaml'

BASE_URL = 'http://www.imdb.com'

def fetch_movies_url
  html_doc = Nokogiri::HTML(open("#{BASE_URL}/chart/top").read)
  html_doc.search('.titleColumn a').take(5).map do |link|
    movie_id = link.attributes['href'].value.match(/\/title\/(?<id>\w{9})/)[:id]
    "#{BASE_URL}/title/#{movie_id}"
  end
end

def scrape_movie(movie_url)
  html_doc = Nokogiri::HTML(open(movie_url).read)
  title_match = html_doc.at('.title_wrapper h1').text.strip.match(/(?<title>.*)[[:space:]]\((?<year>\d{4})\)/)

  title = title_match[:title]
  year = title_match[:year].to_i
  storyline = html_doc.at('.summary_text').text.strip
  director = html_doc.at('.credit_summary_item').text.gsub(/Director:/, '').strip
  cast = html_doc.search('.cast_list tr td:nth-child(2)').take(3).map { |element| element.text.strip }

  {
    cast: cast,
    director: director,
    storyline: storyline,
    title: title,
    year: year
  }
end

def save_top_movies_to_yaml
  top_movies = fetch_movies_url.map { |movie_url| scrape_movie(movie_url) }
  File.open("imdb_top_movies.yml", "w") do |f|
    f.write(top_movies.to_yaml)
  end
end

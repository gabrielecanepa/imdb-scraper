require_relative '../scraper'

describe '#fetch_movies_url' do
  it 'returns an array of movies' do
    expected = [
      'http://www.imdb.com/title/tt0111161',
      'http://www.imdb.com/title/tt0068646',
      'http://www.imdb.com/title/tt0071562',
      'http://www.imdb.com/title/tt0468569',
      'http://www.imdb.com/title/tt0050083'
    ]
    expect(fetch_movies_url).to eq(expected)
  end
end

describe '#scrape_movie' do
  it 'returns an hash with the correct informations' do
    expected = {
      cast: [ 'Christian Bale', 'Heath Ledger', 'Aaron Eckhart' ],
      director: 'Christopher Nolan',
      storyline: 'When the menace known as the Joker emerges from his mysterious past, he wreaks havoc and chaos on the people of Gotham. The Dark Knight must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
      title: 'The Dark Knight',
      year: 2008
    }
    expect(scrape_movie('http://www.imdb.com/title/tt0468569')).to eq(expected)
  end
end

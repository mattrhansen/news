require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

ForecastIO.api_key = "3346c332175cc193b8f51b05c6fc0e39"

get "/" do
    @entry = false
    view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])

    @lat_long = results.first.coordinates # => [lat, long]

    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash

    url = "https://newsapi.org/v2/top-headlines?country=#{results.first.country_code}&apiKey=7f70e635bcf841fbac13e7e5d4f6f196"

    @news = HTTParty.get(url).parsed_response.to_hash
    
    @entry = true

    view "ask"
end
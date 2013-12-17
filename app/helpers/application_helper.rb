module ApplicationHelper

  API_KEY = "31c1986e344b40f5856eb4102f1c2125"
  BASE_URL = "http://openstates.org/api/v1"

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Geocode App"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Lookup legislators by the members given long./lat. coords
  def legislators_by_geocode(longitude, latitude)
    response = RestClient.get BASE_URL + '/legislators/geo/',
               params: { long: longitude, lat: latitude, apikey: API_KEY }
    data = JSON.load(response)
  end

end

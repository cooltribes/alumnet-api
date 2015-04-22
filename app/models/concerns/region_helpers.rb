module RegionHelpers

def countries_info
  if self.countries.any?
    countries.map do |country|
      { id: country.id, text: country.name }
    end
  else
    nil
  end
end

end

json.(album, :id, :name, :description, :cover, :date_taken)

json.city do
  if album.city.present? 
    json.id album.city.id
    json.text album.city.name
  else
    nil
  end      
end

json.country do
  if album.country.present? 
    json.id album.country.id
    json.text album.country.name
  else
    nil
  end
end


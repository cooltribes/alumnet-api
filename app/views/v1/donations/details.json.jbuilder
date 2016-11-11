json.total_sold @total_sold
json.donors @donors
json.countries @countries
json.stats @stats
json.backers @user_products do |user_product|
	json.user_name user_product.user.name
	json.user_avatar user_product.user.avatar.medium.url
  json.total_price user_product.total_price
  json.created_at user_product.created_at
end
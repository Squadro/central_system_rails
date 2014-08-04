json.id current_user.id.to_s
json.merchant_id current_user.merchant_id.to_s
json.(current_user, :name)
json.addresses current_user.addresses do |address|
  json.(address, :line1, :line2, :area, :landmark, :city, :state, :country, :pincode, :full_address)
  json.id address.id.to_s
end

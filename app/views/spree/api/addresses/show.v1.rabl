object @address
attributes :id, :firstname, :lastname, :address1, :address2,
           :city, :zipcode, :phone,
           :company, :alternative_phone, :country_id, :state_id,
           :state_name

# ===== added for the compatibility with Shippo =====
node(:full_name) { |a| "#{a.firstname} #{a.lastname}" }
node(:state_text) { |a| a.try(:state).try(:name) }
# ======================================================

child(:country) do |address|
  attributes :id, :iso_name, :iso, :iso3, :name, :numcode
end
child(:state) do |address|
  attributes :abbr, :country_id, :id, :name
end

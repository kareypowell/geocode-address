json.array!(@members) do |member|
  json.extract! member, :first_name, :middle_name, :last_name, :suffix,
                        :occupation, :member_number, :address, :address_2,
                        :city, :state, :zip, :country, :email, :phone, :phone_wk,
                        :employer, :activity_code, :expiration_date, :longitude,
                        :latitude, :senate_district_no, :senate_name,
                        :senate_phone, :rep_district_no, :rep_name, :rep_phone
  json.url member_url(member, format: :json)
end